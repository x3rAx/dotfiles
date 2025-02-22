#!/bin/sh

start() { "$@" & }
start_delayed() { (
	sleep $1
	shift
	start "$@"
) & }

bspc rule --add "Anydesk"         desktop=8
#bspc rule --add "Rustdesk"        desktop=8  state=tiled
bspc rule --add "Thunderbird"     desktop=9
bspc rule --add "discord"         desktop=9
bspc rule --add "Ferdi"           desktop=10
bspc rule --add "Signal"          desktop=10
bspc rule --add "TelegramDesktop" desktop=10

#start anydesk
#start birdtray
start copyq
#start ferdi
start keepassxc
start kopia-ui-crashsafe
#start rustdesk
start signal-desktop --use-tray-icon # --start-in-tray
start solaar --battery-icons solaar --window hide
start telegram-desktop
start thunderbird
start barrier # mouse / keyboard sharing
#start discord
#start steam -silent
start flatpak run com.valvesoftware.Steam -silent
start razer_battery_tray "Razer Viper Ultimate"
start kdeconnect-indicator
start blueman-applet # Bluetooth UI

start_delayed 2 syncthingtray
