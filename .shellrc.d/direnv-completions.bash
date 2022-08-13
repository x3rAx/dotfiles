__direnv_completions() {
    compopt +o default # Disable default completion

    local cword="$COMP_CWORD"
    local words=( "${COMP_WORDS[@]}" )
    local word="${words[cword]}"
    local line=${COMP_LINE}
    
    if [[ $cword == 1 ]]; then
        COMPREPLY=( $( compgen -W "allow deny edit exec help hook prune reload status stdlib version" -- "$word" ) )
    else
        compopt -o default # Enable default completion
    fi
}
complete -F __direnv_completions direnv