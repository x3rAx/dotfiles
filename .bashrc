# .bashrc
# =======

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# --- START of .shellrc.d ---

    # Replace this with the shell specific file suffix
    # (eg. `bash` for `.bash` files or `zsh` for `.zsh` files)
    __SHELL_SUFFIX='bash'

    _IFS=$IFS
    IFS=$'\n'
    # For POSIX incompatible shells, remove this part ----------------------------------------------------------vvvvvvvvvvvvvvvv
    for f in $(find ~/.shellrc.d -type f \! -name '#*' -and \! -path '*/#*' -and \( -name "*.${__SHELL_SUFFIX}" -or -name '*.sh' \) | sort --ignore-case ); do
        source "$f"
    done

    IFS=$_IFS
    unset _IFS f __SHELL_SUFFIX

# --- END of .shellrc.d ---

