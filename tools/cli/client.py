#!/usr/bin/python3
# -*- coding: utf-8 -*-
"""
Generates an executable for the selected system
"""

import argparse


def main():
    parser = argparse.ArgumentParser(
        prog='client.py',
        description="Generate a new client"
    )

    parser.add_argument(
        'host',
        action='store',
        type=str,
        help='server IP address'
    )

    parser.add_argument(
        'port',
        action='store',
        type=str,
        help='server port number'
    )

    parser.add_argument(
        'modules',
        metavar='module',
        action='append',
        nargs='*',
        help='module(s) to remotely import at run-time'
    )

    parser.add_argument(
        '-v', '--version',
        action='version',
        version='v0.1.0-alpha',
    )

    options = parser.parse_args()


if __name__ == '__main__':
    main()
