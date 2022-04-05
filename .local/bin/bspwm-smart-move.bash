#!/usr/bin/env bash

[ "$#" -eq 1 ] || { echo >&2 "ERROR: Expected one argument: <direction>"; exit 1; }

direction="$1"

[[ $direction =~ ^(north|south|east|west)$ ]] \
    || { echo >&2 "ERROR: Direction must be one of \"north, south, east, west\""; exit 1; }

log() {
    if [[ -z $log ]]; then log=/tmp/bsplog; rm "$log"; fi
    echo >>"$log" "$@"
}

index_of() {
    local needle="$1"
    shift
    local haystack=( "$@" )
    log "index_of ($needle) ${haystack[@]}"
    for i in "${!haystack[@]}"; do
        log "index_of $i ${haystack[$i]} =?= $needle"
        if [[ ${haystack[$i]} == $needle ]]; then
            echo "$i"
            return
        fi
    done
    echo "-1"
}
is_first_child() {
    [[ $(bspc query -N -n) == $(bspc query -N -n @parent/1) ]] || return 1
}
get_self_split_type() {
    node=$(bspc query -N -n @parent); bspc query -T -n $node | jq -r '.splitType'
}
get_target_split_type() {
    # TODO: Make this dependent on the `automatic_scheme` option
    dim=( $(bspc query -T -n $direction | jq '.rectangle.width,.rectangle.height') )
    width="${dim[0]}"
    height="${dim[1]}"
    if (( $width > $height ))
        then echo "vertical"
        else echo "horizontal"
    fi
}
get_movement_type() {
    if [[ $direction =~ ^(north|south)$ ]]
        then echo "vertical"
        else echo "horizontal"
    fi
}
smart_move_to_node() {
    # Move node into target node. Take into account how the target node will
    # split and insert the current node so that it is "closest" to it's
    # previous location
    initial_polarity="$(bspc config initial_polarity)"
    
    if [[ $direction == "north" ]] && [[ $(get_target_split_type) == "horizontal" ]]; then
            bspc config initial_polarity "last_child"
    elif [[ $direction == "east" ]] && [[ $(get_target_split_type) == "vertical" ]]; then
            bspc config initial_polarity "first_child"
    elif [[ $direction == "south" ]] && [[ $(get_target_split_type) == "horizontal" ]]; then
            bspc config initial_polarity "first_child"
    elif [[ $direction == "west" ]] && [[ $(get_target_split_type) == "vertical" ]]; then
            bspc config initial_polarity "last_child"
    fi

    bspc node --to-node "$direction" --follow
    bspc config initial_polarity "$initial_polarity"
}
find_common_ancestor() {
    echo $common_ancestor
    echo $common_ancestor_idx
}

node_brother="$(bspc query -N @brother -n)"
node_direction="$(bspc query -N -n "$direction")"

if [[ -z $node_direction ]]; then
    # When moving to the edge of the monitor, create a new receptacle and move
    # the node to it
    bspc node @/ -p "$direction" -i
    bspc node -n any.leaf.\!window
elif [[ $node_direction == $node_brother ]]; then
    # If target node is brother of current node, just swap them
    bspc node --swap "$direction" --follow
else
    node_ancestors=( $(bspc query -N -n .ancestor_of.\!leaf) )
    log "node_ancestors:   ${node_ancestors[@]}"
    target_ancestors=( $(bspc query -N "${direction}" -n .ancestor_of.\!leaf) )
    log "target_ancestors: ${target_ancestors[@]}"
    common_ancestor=""
    common_ancestor_idx=-1
    for i in "${!node_ancestors[@]}"; do
        if [[ ${node_ancestors[$i]} != ${target_ancestors[$i]} ]]; then
            break
        fi
        common_ancestor="${node_ancestors[$i]}"
        common_ancestor_idx=$i
    done
    log "common_ancestor: $common_ancestor"

    if [[ -n $common_ancestor ]]; then
        split_type="$(bspc query -T -n | jq -r '.splitType')"
        log "split_type: $split_type"
        node_split_type_ancestors=( $(bspc query -N -n .ancestor_of.\!leaf.${split_type}) )
        target_split_type_ancestors=( $(bspc query -N "${direction}" -n .ancestor_of.\!leaf.${split_type}) )
        log "node_split_type_ancestors:   ${node_split_type_ancestors[@]}"
        log "target_split_type_ancestors: ${target_split_type_ancestors[@]}"

        node_ancestors=( "${node_ancestors[@]:$common_ancestor_idx}" )
        target_ancestors=( "${target_ancestors[@]:$common_ancestor_idx}" )
        log '--'
        log "node_ancestors:   ${node_ancestors[@]}"
        log "target_ancestors: ${target_ancestors[@]}"

        idx_node_ancestor=$(index_of "$common_ancestor" "${node_split_type_ancestors[@]}")
        #let idx_node_ancestor++
        idx_target_ancestor=$(index_of $common_ancestor "${target_split_type_ancestors[@]}")
        #let idx_target_ancestor++
        log "idx_node_ancestor   $idx_node_ancestor"
        log "idx_target_ancestor $idx_target_ancestor"
        
        node_split_type_ancestors=( "${node_split_type_ancestors[@]:$idx_node_ancestor}" )
        target_split_type_ancestors=( "${target_split_type_ancestors[@]:$idx_target_ancestor}" )
        log "node_split_type_ancestors:   ${node_split_type_ancestors[@]}"
        log "target_split_type_ancestors: ${target_split_type_ancestors[@]}"

        if (( ${#node_ancestors[@]} == ${#node_split_type_ancestors[@]} )) && (( ${#target_ancestors[@]} == ${#target_split_type_ancestors[@]} )); then
            log swap
            bspc node --swap "$direction" --follow
        else
            log move
            smart_move_to_node
        fi


    else
        smart_move_to_node
    fi
fi

