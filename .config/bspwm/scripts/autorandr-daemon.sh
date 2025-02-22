#!/usr/bin/env bash

while true; do
    xev -root -event randr -1 \
        | grep --line-buffered -P '^RRNotify event, .*, subtype XRROutputPropertyChangeNotifyEvent output .*, property CTM, .*, state NewValue' \
        | while read -r _; do
            if [[ $(autorandr --detected | wc -l) -gt 0 ]]; then
                : autorandr -f -c
            else
                : autorandr -f horizontal
            fi
        done
done

#while true; do
#    while read -r _; do
#        if [[ $(autorandr --detected | wc -l) -gt 0 ]]; then
#            : autorandr -f -c
#        else
#            : autorandr -f horizontal
#        fi
#    done < <(
#        grep --line-buffered -P '^RRNotify event, .*, subtype XRROutputPropertyChangeNotifyEvent output .*, property CTM, .*, state NewValue' < <(
#            xev -root -event randr -1
#        )
#    )
#done
