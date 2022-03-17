# trash-cli.sh

function __rm-disabled() {
    echo >&2 "WARN: Use \`rt\` instead of \`rm\` to move files to trash."
    echo >&2 "      Use \`\\rm\` if you really want to permanently delete files."
    return 1
}

function __empty-trash() {
    echo >&2 -n "Do you really want to PERMANENTLY delete all files in the trash bin? Type uppercase yes to confirm: "
    read answer

    if [[ ${answer} == "YES" ]]; then
        trash-empty
        return
    fi
    
    echo >&2 "=> No files were deleted"
}

alias rm=__rm-disabled

alias rt=trash-put
alias rt-l=trash-list
alias rt-empty=__empty-trash
alias rt-rm=trash-rm
