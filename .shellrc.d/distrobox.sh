dbox() {
    if [ "$1" == "ls" ]; then
        shift
        set -- list "$@"
    elif [ "$1" == "e" ]; then
        shift
        set -- enter "$@"
    fi

    distrobox "$@"
}

__dbox() {
    __load_completion distrobox

    if [[ $COMP_CWORD == 1 ]]; then
        __distrobox
        COMPREPLY=(
            "${COMPREPLY[@]}"
            $(compgen -W "e ls" "${COMP_WORDS[$COMP_CWORD]}")
        )
        return
    fi

    if [[ $COMP_CWORD -gt 1 ]]; then
        case "${COMP_WORDS[1]}" in
            'e') COMP_WORDS[1]='enter';;
            'ls') COMP_WORDS[1]='list';;
        esac
    fi

    __distrobox
}

complete -F __dbox dbox
complete -F __dbox distrobox
