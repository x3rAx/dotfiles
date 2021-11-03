#!/usr/bin/env bash

__SCRIPT__="$(realpath "$0")"
__SCRIPT_DIR__="$(dirname "$__SCRIPT__")"

fifo="$__SCRIPT_DIR__/.fifo"

key="$1"

echo "$key" >>"$fifo"
