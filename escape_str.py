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
    return parser.parse_args()


def main():
    args = parse_args()
    force_escape = ":"
    output = re.escape(args.input)
    for char in force_escape:
        output = output.replace(char, f"\\{char}")
    if args.dont_escape:
        for char in args.dont_escape:
            output = output.replace(f"\\{char}", char)
    print(output, end='')


if __name__ == "__main__":
    main()
