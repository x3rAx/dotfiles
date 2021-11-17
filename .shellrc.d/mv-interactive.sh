function mv() {
    local path="$1"
    if [ "$#" -ne 1 ] || [ ! -e "$path" ]; then
        command mv "$@"
        return
    fi

    read -p '[mv]: ' -ei "$1" newpath
    command mv -v -- "$path" "$newpath"
}