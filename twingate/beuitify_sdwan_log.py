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


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--additional-modules",
        default = "",
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


def pre_defined_http_line(line: str) -> str | None:
    output = search_and_replace(line, r"^(\[.*\]) http\:\:request\:\:send_request\: ([A-Z]*) \"https://(.*)\.com/(.*)\" .*",
                       r"sdwan->\3: \2 \4\\\\n \1")
    output = output or search_and_replace(line, r"^(\[.*\]) http\:\:request\:\:handle_response\: [A-Z]* \"https://(.*)\.com/.*\" (.*) \(.*\)",
                        r"\2->sdwan:\3: \\\\n \1")

    return output


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


def pre_defined_module_changes(line, module, time_str) -> str | None:
    escaped_module = re.escape(module)
    output = search_and_replace(line, f"^\[.*\] {escaped_module}.*state.*from(.*)to(.*)\n", r"State Transition\nfrom\1\nto\2")
    output = output or search_and_replace(line, f"^\[.*\] {escaped_module} (.*)\n", r"\1")
    output = line_fold(output)
    module = re.split("\ |:", module)[0]
    return f"note over {module}: {output} \\n {time_str}"


def line_fold(line) -> str:
    line_array = line.split("\n")
    for i in range(len(line_array)):
        line_array[i] = textwrap.fill(line_array[i], 80, drop_whitespace=False, replace_whitespace=False)

    return "\n".join(line_array).replace('\n', '\\n')


def main():
    args = parse_args()
    modules: set = set()

    for module in args.additional_modules.split(","):
        if module:
            modules.add(module)

    if args.file:
        file = open(args.file, 'r+')
    else:
        file = sys.stdin

    for line in file:
        time_str = had_date(line)
        if time_str is None:
            continue

        module = get_module(line, modules)
        pre_defined_output = pre_defined_http_line(line)
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

            output = f"note over {module}: {wrapped_json} \\n {time_str}"
        else:
            output = pre_defined_module_changes(line, module, time_str)

        print(output)


if __name__ == "__main__":
    main()
