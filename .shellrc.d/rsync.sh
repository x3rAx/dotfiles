__rsync-lazy-complete() {
    __load_completion rsync
    _rsync
}

# Binaries located in ~/.local/bin/
complete -o nospace -F __rsync-lazy-complete rsync-progress
complete -o nospace -F __rsync-lazy-complete rsync-cp
complete -o nospace -F __rsync-lazy-complete rsync-tmp

