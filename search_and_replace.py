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
        "--search",
        help="regEx to search",
    )
    parser.add_argument(
        "--replace", default="",
        help="regex to replace (Optional Param) if none the every finding will be replaced with nothing"
    )
    parser.add_argument(
        "--cmd", default="",
        help="Run a command on the found exp"
    )
    parser.add_argument(
        "--file",
        default="",
        help="the file which needs to be read (optional param) STDIN can be used",
    )
    return parser.parse_args()


def main():
    args = parse_args()

    if args.file:
        file = open(args.file, 'r+')
    else:
        file = sys.stdin

    for line in file:
        update_line = line
        if match := re.match(pattern=args.search, string=line):
            if args.cmd:
                for single_match in match.groups():
                    cmd = args.cmd.replace("{MATCH}", single_match)
                    cmd_output = subprocess.run(cmd, shell=True, check=True, capture_output=True, text=True)
                    update_line = update_line.replace(single_match, cmd_output.stdout)
            else:
                update_line = re.sub(args.search, args.replace or "", line)

        print(update_line, end='')


if __name__ == "__main__":
    main()
