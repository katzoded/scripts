#!/usr/bin/env python3

import os
import sys
import fileinput
import argparse
import re
import subprocess


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--input",
        help="input string to add escape chars",
    )
    parser.add_argument(
        "--dont-escape", default="",
        help="list of chars which you don't want to escape"
    )
    parser.add_argument(
        "--force-escape", default="",
        help="list of chars which you wish to be escaped"
    )
    return parser.parse_args()


def escape_str(input_str, force_escape, dont_escape) -> str:
    output = re.escape(input_str)
    for char in force_escape or "":
        output = output.replace(char, f"\\{char}")

    for char in dont_escape or "":
        output = output.replace(f"\\{char}", char)

    return output

def main():
    args = parse_args()
    force_escape = ":"

    print(escape_str(args.input, force_escape, args.dont_escape), end='')


if __name__ == "__main__":
    main()
