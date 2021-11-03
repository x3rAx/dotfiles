#!/usr/bin/env bash

__SCRIPT__="$(realpath "$0")"
__SCRIPT_DIR__="$(dirname "$__SCRIPT__")"

"${__SCRIPT_DIR__}/solaar-key-daemon.sh" &
