rg-fzf-vim() {
    RG_PREFIX="rg --files-with-matches"
    local file
    file="$(
        FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
            fzf --sort --preview="[[ ! -z {} ]] && rg --pretty --context 5 {q} {}" \
                --phony -q "$1" \
                --bind "change:reload:$RG_PREFIX {q}" \
                --bind "alt-j:preview-down,alt-k:preview-up,alt-h:preview-page-up,alt-l:preview-page-down" \
                --preview-window="70%:wrap"
    )" \
    && echo "opening $file" \
    && vim "$file"
}
