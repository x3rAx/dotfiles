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
    __distrobox
}

complete -F __dbox dbox
