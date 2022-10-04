_bat_cmd=

if [ "$(command -v bat)" ]; then
    _bat_cmd=bat
    alias cat="bat"
elif [ "$(command -v batcat)" ]; then
    _bat_cmd=batcat
    alias cat="batcat"
    alias bat="batcat"
fi

if [[ -n $_bat_cmd ]]; then
    # Use bat to colorize man pages 🤩
    export MANPAGER="sh -c 'col -bx | ${_bat_cmd} -l man -p'"
fi

unset _bat_cmd
