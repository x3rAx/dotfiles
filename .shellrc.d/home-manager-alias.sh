hm() {
    if [ "$1" == "e" ]; then
        shift
        set -- edit "$@"
    elif [ "$1" == "s" ]; then
        shift
        set -- switch "$@"
    fi

    home-manager "$@"
}

__hm() {
    __load_completion home-manager
    _home-manager_completions
}

complete -F __hm hm
