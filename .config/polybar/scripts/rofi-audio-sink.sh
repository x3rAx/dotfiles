#!/usr/bin/env bash

EXCLUDE=(
	easyeffects_sink
	alsa_output.pci-0000_06_04.0.pro-output-1 # Xonar Pro 1 (digital out?)
)

default_sink="$(pactl get-default-sink)"
sinks="$(
	pactl --format json list sinks |
		jq -r -c \
			'''
                $ARGS.positional as $exclude
                | map( select(.name | IN($exclude[]) | not))
            ''' \
			--args "${EXCLUDE[@]}"
)"

default_sink_index="$(
	echo "$sinks" |
		jq -r \
			--arg default_sink "$default_sink" \
			'map(.name) | index($default_sink)'
)"

rofi_input="$(
	echo "$sinks" |
		jq -r \
			--arg default_sink "$default_sink" \
			'
            .[] | (
                if .name == $default_sink then
                    "  "
                else
                    "   "
                end
                + .description
            )
        '
)"

selected_index="$(
	echo "$rofi_input" |
		rofi \
			-dmenu \
			-format 'i' \
			-selected-row "$default_sink_index" \
			-hover-select \
			-me-select-entry '' \
			-me-accept-entry 'MousePrimary'
)"

selected_sink_name="$(
	echo "$sinks" |
		jq -r \
			--argjson selected_index "$selected_index" \
			'.[$selected_index | tonumber].name'
)"

pactl set-default-sink "$selected_sink_name"
