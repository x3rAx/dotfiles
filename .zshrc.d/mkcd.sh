# mkcd
#######

function mkcd() {
    local num="$#"
    local last="${@[num]}"

    mkdir "$@"
    cd "$last"
}
