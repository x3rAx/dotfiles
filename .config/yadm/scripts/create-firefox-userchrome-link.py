#!/usr/bin/env python3

from pathlib import Path
from os import path, symlink
from pathlib import Path
from itertools import islice
import argparse
import configparser
import logging
import random
import string
import sys


def parse_args():
    parser = argparse.ArgumentParser(
            description='Create a symlink to the `userChrome.css` file in the default Firefox profile folder',
            formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    parser.add_argument('file',
                        help="Path to the `userChrome.css` file",
                        type=Path,
                        metavar="userchrome-file")

    parser.add_argument('profiles_ini',
                        help="Path to the Firefox `profiles.ini`",
                        type=Path,
                        metavar="firefox-profiles-ini",
                        nargs='?',
                        default="~/.mozilla/firefox/profiles.ini")

    return parser.parse_args()


def get_random_string(length):
    letters = string.ascii_letters + string.digits
    return ''.join(random.choice(letters) for _ in range(length))


def parse_config(file, global_section_name):
    file = path.expanduser(file)
    with open(file) as f:
        file_content = f"[{global_section_name}]\n" + f.read()

    config = configparser.ConfigParser()
    config.read_string(file_content)

    return config


def create_symlink(file: Path, firefox_dir: Path, profile_conf: dict):
    profile_dir = Path(profile_conf['path'])
    profile_dir = (
            firefox_dir / profile_dir
            if profile_conf['isrelative'] == '1'
            else profile_dir)
    chrome_dir = profile_dir / 'chrome'
    link = chrome_dir / 'userChrome.css'


    chrome_dir.mkdir(exist_ok=True)

    #file = file.expanduser()
    #link = link.expanduser()

    if link.exists():
        if link.is_symlink() and link.resolve() == file:
            print(f'Link to `userChrome.css` already exists')
            return

        print(f'ERROR: `{link}` already exists', file=sys.stderr)
        return

    userhome_file = '~' / file.relative_to(Path.home())
    userhome_link = '~' / link.relative_to(Path.home())

    relative_file = path.relpath(file, link.parent)

    print(f'Creating link: {userhome_link} -> {userhome_file}', file=sys.stderr)
    symlink(relative_file, link)


def main():
    args = parse_args()

    global_section_name = "MAIN_" + get_random_string(10)

    config = parse_config(args.profiles_ini, global_section_name)

    for section in islice(config.sections(), 1, None):
        if 'default' in config[section] and config[section]['default'] == '1':
            create_symlink(args.file, Path(args.profiles_ini).parent, config[section])
            return

    print('ERROR: Firefox `profiles.ini` does not contain a default profile', file=sys.stderr)


if __name__ == "__main__":
    main()
