function ranger-cd {
    local IFS=$'\t\n'
    local tempfile="$(mktemp -t tmp.XXXXXX)"

    command ranger \
        --cmd="map Q chain shell echo %d > \"$tempfile\"; quitall" \
        "$@"

    if [[ -f "$tempfile" ]] && [[ "$(cat -- "$tempfile")" != $(pwd) ]]; then
        cd -- "$(cat -- "$tempfile")" || return
    fi
    command rm -f -- "$tempfile" 2>/dev/null
}

alias ranger=ranger-cd
alias r=ranger
