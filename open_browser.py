#!/usr/bin/env python3

import os
import sys
import fileinput
import argparse
import re
import subprocess
import urllib.parse
import webbrowser


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--url",
        default="",
        help="the url to open",
    )
    parser.add_argument(
        "--param",
        default="",
        help="the param to add in URL",
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

    param_str = "".join([line for line in file])
    quote_param_str = urllib.parse.quote(param_str)

    url = f"{args.url}{args.param}={quote_param_str}"

    print(f"open browser with {url}")
    webbrowser.open(url)


if __name__ == "__main__":
    main()
