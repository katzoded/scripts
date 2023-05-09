#!/usr/bin/env python3
import json
import os
import sys
import fileinput
import argparse
import re
import subprocess
import textwrap
from search_and_replace import search_and_replace
import urllib.parse
import webbrowser
from datetime import datetime
import calendar

subprocess.check_call([sys.executable, '-m', 'pip', 'install', 'python-dateutil'])
from dateutil.parser import parse as date_parse


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--additional-modules",
        default="(\[.*?\]) ,",
        help="additional modules to extract from logs",
    )
    parser.add_argument(
        "--split",
        default=True,
        help="split the flow into smaller pieces",
    )
    parser.add_argument(
        "--file",
        default="",
        help="the file which needs to be read (optional param) STDIN can be used",
    )
    parser.add_argument(
        "--date-regex",
        default=r"^(\[.*[0-9]\]) ",
        help="define the date regex",
    )
    return parser.parse_args()


def get_all_modules_with_json(file, date_regex_no_place_holder: str) -> set:
    all_modules = set()
    for line in file:
        all_modules.add(search_and_replace(line, search=f"{date_regex_no_place_holder}(.*) {{.*}}.*", replace="\1"))

    return all_modules


def get_module(line: str, modules: list, date_regex_no_place_holder: str) -> str | None:
    for module in modules:
        if module_name := search_and_replace(line, f"{date_regex_no_place_holder}{module}.*\n", r"\1"):
            return module_name

    return None


def has_json(line: str) -> dict | None:
    found_json = {}

    start = 0
    while True:
        found_str, start, end = find_closing(line, start, "{", "}")
        if found_str is None:
            break

        start = end
        try:
            json_dict = json.loads(found_str)
        except Exception as e:
            continue

        found_json[found_str] = json_dict

    return found_json


def pre_defined_http_line(line: str, date_regex: str) -> tuple[str, list] | None:
    if match := re.search(f"{date_regex}http\:\:request\:\:send_request\: ([A-Z]*) \"https://(.*)\.com/(.*)\" .*\n", line):
        return create_output_for_2_modules(match.groups()[0], "sdwan", match.groups()[2], f"{match.groups()[1]} {match.groups()[3]}")

    if match:= re.search(f"{date_regex}http\:\:request\:\:handle_response\: [A-Z]* \"https://(.*)\.com/(.*)\" (.*) \(.*\)\n", line):
        return create_output_for_2_modules(match.groups()[0], match.groups()[1], "sdwan",
                                           f"{match.groups()[3]} on {match.groups()[2]}")
    return None


def had_date(line: str, date_regex: str) -> str | None:
    return search_and_replace(line, f"{date_regex}.*\n", r"\1")


def find_closing(line, index, opening, closing) -> tuple[str | None, int | None, int | None]:
    items = []
    start = -1
    for i, c in enumerate(line[index:]):
        iter_i = index + i
        if c == opening:
            if start == -1:
                start = iter_i
            items.append(iter_i)
        if c == closing:
            items.pop()
        if len(items) == 0 and start > 0:
            return line[start:iter_i + 1], start, iter_i + 1

    return None, None, None


def pre_defined_module_changes(line, module, time_str, date_regex_no_place_holder) -> str | None:
    escaped_module = re.escape(module)
    output = search_and_replace(line, f"{date_regex_no_place_holder}{escaped_module}.*state.*from(.*)to(.*)\n", r"State Transition\nfrom\1\nto\2")
    output = output or search_and_replace(line, f"{date_regex_no_place_holder}{escaped_module}(.*)\n", r"\1")
    output = line_fold(output)
    return create_output(time_str, output)


def line_fold(line) -> str:
    line_array = line.split("\n")
    for i in range(len(line_array)):
        line_array[i] = textwrap.fill(line_array[i], 80, drop_whitespace=False, replace_whitespace=False)

    return "\n".join(line_array).replace('\n', '\\n')


def is_curl_str(line) -> str | None:
    return search_and_replace(line, f"^[\<\>] (.*)\n", r"\1\n")


def get_sorted_modules(modules_dict):
    return sorted(modules_dict.items(), key=lambda item: item[1], reverse=True)


def add_to_module_dict(modules_dict: dict, module):
    modules_dict[module] = modules_dict[module] + 1 if modules_dict.get(module) else 1


def create_output(time_str, text) -> str:
    return f"{text} \\n {time_str}"


def create_output_for_2_modules(time_str, src_module, dst_module, text) -> tuple[str, list]:
    src_module = src_module.replace(":", "")
    dst_module = dst_module.replace(":", "")

    return f"{text}\\n {time_str}", [src_module, dst_module]


def convert_time_str_to_time(time_str) -> int:
    time_str = time_str.replace("[", "")
    time_str = time_str.replace("]", "")
    time_str = time_str.split(".")
    datetime_str = time_str[0]
    millisec = time_str[1].split('-')[0]

    if len(millisec) == 3:
        millisec = f"{millisec}000"

    epoc = calendar.timegm(date_parse(datetime_str).timetuple()) * 1000000

    return epoc + int(millisec)


def get_participant_modules_from_lines(output_lines: list) -> dict:
    modules_dict = {}
    for line in output_lines:
        for module in line["modules"]:
            add_to_module_dict(modules_dict, module.replace(":", ""))

    return modules_dict


def get_output_lines_separation(output_lines, do_separate_flows):
    if not do_separate_flows:
        yield output_lines
        return

    prev_date_val_ms = convert_time_str_to_time(output_lines[0]["time_str"])
    first_line = 0
    for i, line in enumerate(output_lines):
        curr_date_val_ms = convert_time_str_to_time(line["time_str"])
        if curr_date_val_ms - prev_date_val_ms > 50000:
            yield output_lines[first_line: i]
            first_line = i

        prev_date_val_ms = curr_date_val_ms


def format_output_by_modules(modules) -> str:
    if len(modules) == 2:
        return f"{modules[0]}->{modules[1]}:"
    return f"note over {modules[0]}:"


def get_output_similar_module_lines(output_lines):
    modules = None
    output = ""
    first_line = 0
    for i, line in enumerate(output_lines):
        if modules != line["modules"]:
            if modules:
                yield output
            modules = line["modules"]
            output = format_output_by_modules(modules)
            first_line = i

        output = f"{output} [{i - first_line}]{line['output']}\\n"


def print_output(output_lines, title, do_separate_flows):
    output_line_generator = get_output_lines_separation(output_lines, do_separate_flows)

    for flow_lines in output_line_generator:
        print(title)
        sorted_modules = get_sorted_modules(get_participant_modules_from_lines(flow_lines))
        for module_tuple in sorted_modules:
            print(f"participant {module_tuple[0].replace(' ', '')}")

        print(f"note over {sorted_modules[0][0].replace(' ', '')}, {sorted_modules[-1][0].replace(' ', '')}: new event")
        for output in get_output_similar_module_lines(flow_lines):
            print(output)

        for module_tuple in sorted_modules:
            print(f"destroysilent {module_tuple[0].replace(' ', '')}")


def main():
    output_lines = []
    title =""
    args = parse_args()
    modules: list = []

    for module in args.additional_modules.split(","):
        if module:
            modules.append(module)

    if args.file:
        file = open(args.file, 'r+')
        title = f"title {args.file.split('/')[-1]}"
    else:
        file = sys.stdin

    last_timestamp = ""
    multiline_str = ""
    date_regex = args.date_regex
    date_regex_no_place_holder = date_regex
    date_regex_no_place_holder = date_regex_no_place_holder.replace("(", "")
    date_regex_no_place_holder = date_regex_no_place_holder.replace(")", "")
    for line in file:
        pre_defined_output_tuple = None
        time_str = had_date(line, date_regex)
        if time_str is None:
            if curr_curl_line := is_curl_str(line):
                 multiline_str += curr_curl_line
                 continue
            else:
                if multiline_str:
                    source = "sdwan"
                    dest = "curl"
                    if re.search("^HTTP.*", multiline_str):
                        source, dest = dest, source

                    time_str = last_timestamp
                    pre_defined_output_tuple = create_output_for_2_modules(time_str, source, dest, line_fold(multiline_str))
                    multiline_str = ""
                else:
                    continue

        last_timestamp = time_str

        module = get_module(line, modules, date_regex_no_place_holder)
        pre_defined_output_tuple = pre_defined_output_tuple or pre_defined_http_line(line, date_regex)
        found_json_dict = has_json(line)
        if not found_json_dict and module is None and pre_defined_output_tuple is None:
            continue

        output_modules = [module] if pre_defined_output_tuple is None else pre_defined_output_tuple[1]
        if pre_defined_output_tuple:
            output = pre_defined_output_tuple[0]
        elif found_json_dict:
            wrapped_json = ""
            for found_json_str, found_json_dict in found_json_dict.items():
                json_str = json.dumps(found_json_dict, indent=1)
                json_str += "\n"
                wrapped_json += line_fold(json_str)
                if module is None:
                    escaped_json = re.escape(found_json_str)
                    module = search_and_replace(line, f"{date_regex_no_place_holder}(.*){escaped_json}", r"\1")
                    module = re.split("\ |:", module)[0]
                    output_modules = [module]

            output = create_output(time_str, wrapped_json)
        else:
            output = pre_defined_module_changes(line, module, time_str, date_regex_no_place_holder)

        if not output:
            continue

        output_lines.append({"time_str": time_str, "output": output, "modules": output_modules})

    print_output(output_lines, title, args.split)

if __name__ == "__main__":
    main()
