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

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--additional-modules",
        default="",
        help="additional modules to extract from logs",
    )
    parser.add_argument(
        "--file",
        default="",
        help="the file which needs to be read (optional param) STDIN can be used",
    )
    return parser.parse_args()


def get_all_modules_with_json(file) -> set:
    all_modules = set()
    for line in file:
        all_modules.add(search_and_replace(line, search="^\[.*[0-9]\] (.*) \{.*\}.*", replace="\1"))

    return all_modules


def get_module(line: str, modules: set) -> str | None:
    for module in modules:

        if module_name := search_and_replace(line, f"^\[.*[0-9]\] ({module}).*\n", r"\1"):
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


def pre_defined_http_line(modules_dict, line: str) -> str | None:
    if match := re.search(r"^(\[.*\]) http\:\:request\:\:send_request\: ([A-Z]*) \"https://(.*)\.com/(.*)\" .*\n", line):
        return create_output_for_2_modules(modules_dict, match.groups()[0], "sdwan", match.groups()[2], f"{match.groups()[1]} {match.groups()[3]}")

    if match:= re.search(r"^(\[.*\]) http\:\:request\:\:handle_response\: [A-Z]* \"https://(.*)\.com/.*\" (.*) \(.*\)\n", line):
        return create_output_for_2_modules(modules_dict, match.groups()[0], match.groups()[1], "sdwan",
                                           {match.groups()[2]})
    return None


def had_date(line: str) -> str | None:
    return search_and_replace(line, r"^(\[.*[0-9]\]) .*\n", r"\1")


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


def pre_defined_module_changes(modules_dict, line, module, time_str) -> str | None:
    escaped_module = re.escape(module)
    escaped_time_str = re.escape(time_str)
    output = search_and_replace(line, f"^{escaped_time_str} {escaped_module}.*state.*from(.*)to(.*)\n", r"State Transition\nfrom\1\nto\2")
    output = output or search_and_replace(line, f"^{escaped_time_str} {escaped_module}(.*)\n", r"\1")
    output = line_fold(output)
    module = re.split("\ |:", module)[0]
    return create_output(modules_dict, time_str, module, output)


def line_fold(line) -> str:
    line_array = line.split("\n")
    for i in range(len(line_array)):
        line_array[i] = textwrap.fill(line_array[i], 80, drop_whitespace=False, replace_whitespace=False)

    return "\n".join(line_array).replace('\n', '\\n')


def is_curl_str(line) -> str | None:
    return search_and_replace(line, f"^[\<\>] (.*)\n", r"\1\n")


def get_sorted_modules(modules_dict):
    return sorted(modules_dict.items(), key=lambda item: item[1], reverse=True)


def create_output(modules_dict: dict, time_str, module, text) -> str:
    module = module.replace(":", "")
    modules_dict[module] = modules_dict[module] + 1 if modules_dict.get(module) else 1

    return f"note over {module}: {text} \\n {time_str}"


def create_output_for_2_modules(modules_dict: dict, time_str, src_module, dst_module, text) -> str:
    src_module = src_module.replace(":", "")
    dst_module = dst_module.replace(":", "")
    modules_dict[src_module] = modules_dict[src_module] + 1 if modules_dict.get(src_module) else 1
    modules_dict[dst_module] = modules_dict[dst_module] + 1 if modules_dict.get(dst_module) else 1

    return f"{src_module}->{dst_module}:{text}\\n {time_str}"


def convert_time_str_to_time(time_str) -> int:
    if match := re.search("\[(.*)\.([0-9]*)\]", time_str):
        datetime_str = match.groups()[0]
        millisecond_str = match.groups()[1]

        epoc = calendar.timegm(datetime.strptime(datetime_str, "%Y-%m-%d %H:%M:%S").timetuple()) * 1000000
        return epoc + int(millisecond_str)

    return 0


def main():
    output_lines = []
    title =""
    args = parse_args()
    modules: set = set()

    for module in args.additional_modules.split(","):
        if module:
            modules.add(module)

    if args.file:
        file = open(args.file, 'r+')
        title = f"title {args.file.split('/')[-1]}"
    else:
        file = sys.stdin

    last_timestamp = ""
    multiline_str = ""
    modules_dict = {}
    from datetime import datetime

    prev_date_val_ms = convert_time_str_to_time("")
    for line in file:
        pre_defined_output = ""
        time_str = had_date(line)
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
                    pre_defined_output = create_output_for_2_modules(modules_dict, time_str, source, dest, line_fold(multiline_str))
                    multiline_str = ""
                else:
                    continue

        curr_date_val_ms = convert_time_str_to_time(time_str)
        if curr_date_val_ms - prev_date_val_ms > 50000:
            output_lines.append("ExternalEvent")

        last_timestamp = time_str
        prev_date_val_ms = curr_date_val_ms

        module = get_module(line, modules)
        pre_defined_output = pre_defined_output or pre_defined_http_line(modules_dict, line)
        found_json_dict = has_json(line)
        if not found_json_dict and module is None and pre_defined_output is None:
            continue

        if pre_defined_output:
            output = pre_defined_output
        elif found_json_dict:
            wrapped_json = ""
            for found_json_str, found_json_dict in found_json_dict.items():
                json_str = json.dumps(found_json_dict, indent=1)
                json_str += "\n"
                wrapped_json += line_fold(json_str)
                if module is None:
                    escaped_json = re.escape(found_json_str)
                    module = search_and_replace(line, f"^\[.*\] (.*){escaped_json}", r"\1")
                    module = re.split("\ |:", module)[0]

            output = create_output(modules_dict, time_str, module, wrapped_json)
        else:
            output = pre_defined_module_changes(modules_dict, line, module, time_str)

        if not output:
            continue

        output_lines.append(output)

    print(title)
    sorted_modules = get_sorted_modules(modules_dict)
    for module_tuple in sorted_modules:
        print(f"participant \"{module_tuple[0]}\\n {module_tuple[1]}\" as {module_tuple[0]}")

    for line in output_lines:
        if line == "ExternalEvent":
            print(f"note over {sorted_modules[0][0]},{sorted_modules[-1][0]}: line")
            continue
        print(line)


if __name__ == "__main__":
    main()
