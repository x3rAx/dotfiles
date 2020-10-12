# trash-cli.sh

function rm-disabled() {
    echo >&2 "WARN: Use \`rt\` instead of \`rm\` to move files to trash."
    echo >&2 "      Use \`\\rm\` if you really want to permanently delete files."
}

alias rt=trash-put
alias rm=rm-disabled

