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

# Kill other instances
script_path=$(readlink -f "$0")
current_pid=$$
other_pids=$(pgrep -f "$script_path" | grep -v "^${current_pid}$")
if [ -n "$other_pids" ]; then
  echo "Killing other instances: $other_pids"
  kill $other_pids
fi


get_connected() {
    xrandr --query | grep " connected" | cut -d' ' -f1
}


get_primary() {
    xrandr --query | grep " connected" | grep " primary" | head -n1 | cut -d' ' -f1
}


start_polybar() {
    # Terminate already running bar instances
    pkill -x polybar || pkill -x '.polybar-wrappe'
    sleep 1
    wait


    if ! command -v xrandr >/dev/null; then
        polybar --reload primary &
        return
    fi


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
}

while true; do
    # Run in subshell so `wait -n` will not continue when old subprocesses exit
    # due to the force kill at the beginning
    (
        start_polybar
        wait -n
    )
done
