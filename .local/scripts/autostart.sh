#!/usr/bin/env bash

start() {
    "$@" &
}

start ~/.local/scripts/solaar-keys/solaar-key-daemon.sh

start anydesk
start copyq
start signal-desktop --use-tray-icon # --start-in-tray
start solaar --battery-icons solaar --window hide
start telegram-desktop
