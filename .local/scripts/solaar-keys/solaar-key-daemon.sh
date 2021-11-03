#!/usr/bin/env bash

__SCRIPT__="$(realpath "$0")"
__SCRIPT_DIR__="$(dirname "$__SCRIPT__")"

fifo="$__SCRIPT_DIR__/.fifo"

if [[ -e "$fifo" ]]; then
    rm "$fifo"
fi

mkfifo "$fifo"

declare -A key_times
declare -A key_counts

while read key <"$fifo"; do
    # echo $key
    timestamp="$(date +%s.%N)"

    if [[ -z ${key_times[$key]} ]]; then
        key_times[$key]="$timestamp"
        key_counts[$key]="0"
        continue
    fi

    first_time="${key_times[$key]}"

    delta="$(python -c "print(int(($timestamp - $first_time) * 1000))")"
    # python -c "print(':', $first_time, $timestamp)"
    # echo $delta

    if [[ $delta -gt 700 ]]; then
        # echo reset
        key_times[$key]="$timestamp"
        key_counts[$key]="0"
        continue
    fi

    let "key_counts[$key]++"

    if [[ ${key_counts[$key]} -lt 5 ]]; then
        continue
    fi

    echo "SEND KEY: $key"
    xdotool key "$key"
    key_times[$key]="$timestamp"
    key_counts[$key]="0"
done