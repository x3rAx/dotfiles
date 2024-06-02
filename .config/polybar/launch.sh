#!/usr/bin/env bash

## Terminate already running bar instances
#killall -q polybar
## If all your bars have ipc enabled, you can also use 
## polybar-msg cmd quit
#
## Launch bar1 and bar2
#echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
#polybar -r main 2>&1 | tee -a /tmp/polybar1.log & disown
##polybar bar2 2>&1 | tee -a /tmp/polybar2.log & disown
#
#echo "Bars launched..."
#
####################################

# Terminate already running bar instances
killall -q polybar


if ! command -v xrandr >/dev/null; then
  polybar --reload primary &
  exit
fi


get_connected() {
    xrandr --query | grep " connected" | cut -d' ' -f1
}


get_primary() {
    xrandr --query | grep " connected" | grep " primary" | head -n1 | cut -d' ' -f1
}


# Primary
primary="$(get_primary)"

log_tpl="/tmp/polybar-%s.$(date +%s).log"

for monitor in $(get_connected); do
    log="$(printf "$log_tpl" "$monitor")"

    # If there is no primary monitor, fall back to using first one as primary
    if [[ -z $primary ]]; then primary="$monitor"; fi

    # Primary
    if [[ $monitor == $primary ]]; then
        MONITOR=$monitor polybar --reload primary >"$log" &
        continue
    fi

    # Secondaries
    MONITOR=$monitor polybar --reload secondary >"$log" &
done
