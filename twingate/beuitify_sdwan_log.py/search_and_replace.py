#!/usr/bin/env python3
import json
import os
import sys
import fileinput
import argparse
import re
import subprocess
from ..search_and_replace import search_and_replace


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


def get_module(line:str, modules:set)->str|None:
    for module in modules:
        if match:= re.search(f"^\[.*[0-9]\] ({module})", line):
            return match.groups[0]

    return None


def has_json(line:str)->dict|None:
    firstValue = line.index("{")
    lastValue = len(line) - line[::-1].index("}")
    jsonString = jsonStringEncoded[firstValue:lastValue]

    try:
        json_dict = json.loads(jsonString)
    except:
        return None

    return json_dict


def pre_defined_changes(line:str)->str|None:
    output = search_and_replace(line, "^(\[.*\]) http\:\:request\:\:send_request\: ([A-Z]*) \"https://(.*)\.com/(.*)\" .*",
                       "sdwan->\3: \2 \4\\\\n \1")
    output = output or search_and_replace(line, "^(\[.*\]) http\:\:request\:\:handle_response\: [A-Z]* \"https://(.*)\.com/.*\" (.*) \(.*\)",
                        "\2->sdwan:\3: \\\\n \1")

    return output


def main():
    args = parse_args()

    modules: set = {"http.*send_request", "http.*handle_response", args.additional_modules.split(",")}

    if args.file:
        file = open(args.file, 'r+')
    else:
        file = sys.stdin

    for line in file:
        output = pre_defined_changes(line)
        found_json = has_json(line)
        module = get_module(line, modules)
        if module:
            if not output:
                output = search_and_replace(line,
                                            "^(\[.*\]) http\:\:request\:\:send_request\: ([A-Z]*) \"https://(.*)\.com/(.*)\" .*",
                                            "sdwan->\3: \2 \4\\\\n \1")


        else:
            output = None




        print(output, end='')


if __name__ == "__main__":
    main()
