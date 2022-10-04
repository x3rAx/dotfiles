npm() {
    if [ "$(command -v pnpm)" ]; then
        pnpm "$@"
        return
    fi
    command npm "$@"
}