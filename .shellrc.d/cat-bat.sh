_bat_cmd=

if [ "$(command -v bat)" ]; then
    _bat_cmd=bat
    alias cat="bat"
elif [ "$(command -v batcat)" ]; then
    _bat_cmd=batcat
    alias cat="batcat"
    alias bat="batcat"
fi

unset _bat_cmd
