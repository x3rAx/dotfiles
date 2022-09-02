
mkcdtmp() {
    local name="${1:-}"
    local PREFIX='mkcdtmp'
    if [[ -z $name ]]; then
        cd "$(mktemp --tmpdir -d "${PREFIX}.XXXXXXXXXX")"
        return
    fi
    local tmp="$(dirname "$(mktemp -u)")"
    local tmpdir="${tmp}/${PREFIX}.${name}"
    mkdir -- "$tmpdir" || return 1
    cd -- "$tmpdir"
}