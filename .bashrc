# .bashrc
# =======

# --- START of .shellrc.d ---

    # Replace this with the shell specific file suffix
    # (eg. `bash` for `.bash` files or `zsh` for `.zsh` files)
    __SHELL_SUFFIX='bash'

    IFS=$'\n'
    # For POSIX incompatible shells, remove this part -------------------------------------vvvvvvvvvvvvvvvv
    for f in $(find ~/.shellrc.d -type f \! -name '#*' -and \( -name "*.${__SHELL_SUFFIX}" -or -name '*.sh' \) | sort ); do
        source "$f"
    done

    unset IFS f __SHELL_SUFFIX

# --- END of .shellrc.d ---

