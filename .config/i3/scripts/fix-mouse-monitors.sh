#!/bin/bash

MIN_SPEED="1"
MAX_SPEED="1.75"

main() {
    local monitors="${1:-1}"
    local minSpeed="$(calc "$MAX_SPEED / $monitors")"
    local maxSpeed="$(calc "$MAX_SPEED / $monitors")"

    synclient MinSpeed="$minSpeed"
    synclient MaxSpeed="$maxSpeed"
}

calc() {
    bc <<< "scale=2; $1"
}

main "$@"

