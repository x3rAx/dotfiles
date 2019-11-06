#!/usr/bin/env python3

import re
from subprocess import PIPE
from sys import argv
from sys import exit
from sys import stderr
from os import environ
from os import path
from subprocess import run
from subprocess import Popen

class Prop:
    key = None
    value = None

    def __init__(self, key, value):
        self.key = key
        self.value = value


class Sink:
    number = None
    name = None
    volume = None
    mute = None

    def __init__(self, number):
        self.number = number


def usage():
    name = path.basename(argv[0])
    print('Usage:')
    print(f'  {name} <action> [arguments...]')
    print()
    print('ACTIONS:')
    print('    get-volume <sink-name>')
    print('        Get the volume of a given sink. See the information about')
    print('        the "sink-name" parameter in the parameter description')
    print('        below.')
    print('')
    print('    set-volume <sink-name> <volume>')
    print('        Set the volume of a given sink to the specified volume.')
    print('        See the information about the "sink-name" parameter in the')
    print('        parameter description below.')
    print('        The volume could either be absolute (e. g. "20%") or')
    print('        relative (e. g. "+5%").')
    print('')
    print('    set-mute <sink-name> 1|0|toggle')
    print('        Mute / unmute the given sink. See the information about')
    print('        the "sink-name" parameter in the parameter description')
    print('        below.')
    print('        "1" mutes the sink, "0" unmutes and "toggle" toggles the')
    print('        mute state.')
    print('')
    print('PARAMETERS')
    print('    sink-name:')
    print('        The sink name could either be the full name or the')
    print('        beginning of the name. If the name would match')
    print('        multiple sinks, the first one found will be used.')
    print('        So make sure the searched name is unambiguous.')
    print('')

def main():
    require_argv_len(2)
    action = argv[1]

    if action == 'help' or action == '--help' or action == '-h':
        usage()

    elif action == 'get-volume':
        require_argv_len(3)
        get_volume(argv[2])

    elif action == 'set-volume':
        require_argv_len(4)
        set_volume(argv[2], argv[3])

    elif action == 'set-mute':
        require_argv_len(4)
        set_mute(argv[2], argv[3])

    else:
        usage()
        exit(1)

def require_argv_len(length):
    if len(argv) < length:
        print('ERROR: Not enought arguments.')
        exit(1)

def get_volume(sink_name):
    sink = find_sink(sink_name)

    if sink.mute:
        print('MUTE')
    else:
        print(f'{sink.volume}%')


def set_volume(sink_name, volume):
    sink = find_sink(sink_name)

    run(['pactl', 'set-sink-volume', sink.name, volume])


def set_mute(sink_name, mute):
    sink = find_sink(sink_name)

    if mute in ['1', '0', 'toggle']:
        run(['pactl', 'set-sink-mute', sink.name, mute])
    else:
        print(f'ERROR: Invalid parameter "{mute}". Expected "1" | "0" | "toggle".', file=stderr)
        exit(1)


def sink_info(instance):
    result = Popen(['pactl', 'list', 'sinks'], stdout = PIPE)

    sink = None

    for line in result.stdout:
        line = line.decode('utf-8').rstrip()
        indent = indent_level(line)

        if indent == 0:
            prop = parse_line(line, sep=' #')

            if not prop.key == 'Sink':
                continue

            if sink is not None:
                # A sink does already exist, we do not need to parse a new one
                break

            # new sink
            sink = Sink(prop.value)
        elif sink == None:
            continue
        elif indent == 1:
            prop = parse_line(line)

            if prop.key == 'Name':
                name = prop.value

                if not name.startswith(instance):
                    # Set sink to None to indicate that the current parsed
                    # sink is not the searched.
                    sink = None
                    continue

                sink.name = prop.value
            elif prop.key == 'Volume':
                sink.volume = parse_volume(prop.value)
            elif prop.key == 'Mute':
                sink.mute = (prop.value == 'yes')


    return sink


def parse_volume(volume_str):
    # Volume string seems to be
    #   front-left: <raw-value> / <percent>% / <decibel> db, front-right: ...
    volumes = re.findall('([0-9]+)%', volume_str)

    return volumes[0]


def parse_line(line, sep=': '):
    line = line.strip()
    res = line.split(sep, 1)

    return Prop(res[0], res[1] if len(res) == 2 else None)


def indent_level(line, tabsize=4):
    # Expand tabs to spaces
    line = line.expandtabs(tabsize)

    # Check if line consists of whitespaces
    if line.isspace():
        spaces = 0
    else:
        spaces = len(line) - len(line.lstrip())

    return int(spaces / tabsize)


def env(name, default = None):
    if (name in environ):
        return environ[name]
    else:
        return default

if __name__ == '__main__':
    main()
