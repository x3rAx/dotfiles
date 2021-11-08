#!/usr/bin/env bash

start() {
    "$@" &
}

start ~/.local/scripts/solaar-keys/solaar-key-daemon.sh

start anydesk
start birdtray
start copyq
start ferdi
start keepassxc
start signal-desktop --use-tray-icon # --start-in-tray
start solaar --battery-icons solaar --window hide
start sxhkd
start syncthingtray
start telegram-desktop
start thunderbird
