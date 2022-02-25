#!/bin/sh

start ~/.local/scripts/solaar-keys/solaar-key-daemon

bspc rule --add "Anydesk" desktop=8
    start anydesk
start birdtray
start copyq
bspc rule --add "Ferdi" desktop=10
    start ferdi
start keepassxc
bspc rule --add "Signal" desktop=10
    start signal-desktop --use-tray-icon # --start-in-tray
start solaar --battery-icons solaar --window hide
start syncthingtray
bspc rule --add "TelegramDesktop" desktop=9
    start telegram-desktop
bspc rule --add "Thunderbird" desktop=9
    start thunderbird
start kopia-ui-crashsafe
