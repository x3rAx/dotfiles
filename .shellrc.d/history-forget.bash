alias forget='history-forget'

history-forget() {
    history -n # Sync history from file

    local header="=> Select multiple lines with TAB. Confirm deletion with ENTER.\n=> Cancel with Ctrl+C"
    local delete_list="$(history | sort --reverse | fzf --multi --header="$(echo -e "\n${header}\n ")" | sort -n)"

    echo "$delete_list"

    echo >&2    "-------------------------------------------------------------"
    echo >&2 -n "The above lines will be removed from history. Continue? [y/N] "
    read inp
    if [[ ${inp^^} != "Y" ]]; then
        echo >&2 "Aborting..."
        return
    fi

    local offsets="$(echo "$delete_list" | awk '{ print $1 }')"

    # When removing one line from history, all offsets below that line are
    # decremented by 1. To account for that, first sort the offsets and then
    # reduce the first offset by 0, the second offset by 1 and so on.
    local offsets_adapted="$(echo "$offsets" | sort -n | awk 'BEGIN { i = 0; } { print $0 - i; i++; }')"

    local i
    for i in $offsets_adapted; do
        history -d "$i"
    done

    history -w # Write the history to file

    echo >&2 "Done"
}
