# config-aliases

#########
# Lines starting with
#   "%" will be prepended with
#       ${XDG_CONFIG_HOOE:-"$HOME/.config"}
#   "~" will be prepended with
#       ${HOME}

alias .bspwm='edit-config %/bspwm bspwmrc'
alias .conf='edit-config ~/.zshrc.d config-aliases.sh'
alias .i3-blocks='edit-config %/i3/i3blocks config'
alias .i3-sxhkd='edit-config %/i3 sxhkdrc'
alias .i3='edit-config %/i3 config && i3-msg reload >/dev/null'
alias .nvim='edit-config %/nvim init.vim'
alias .sxhkd='edit-config %/sxhkd sxhkdrc'
alias .vim='edit-config ~/ .vimrc'
alias .st='edit-config ~/.local/opt/suckless/st config.h'





# cd to the directory and open the file
function edit-config() {
    local dir="$1"
    local file="$2"

    if [[ $dir =~ ^~ ]]; then
        dir="${HOME}${dir:1}"
    elif [[ $dir =~ ^% ]]; then
        local config="${XDG_CONFIG_HOME:-"${HOME}/.config"}"
        dir="${config}${dir:1}"
    fi

    pushd "$dir" >/dev/null
    $EDITOR "$file"
    popd >/dev/null
}

