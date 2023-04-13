#!/usr/bin/env python3

import os
import sys
import fileinput
import argparse
import re


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
        print(re.sub(args.search, args.replace, line), end='')


if __name__ == "__main__":
    main()
