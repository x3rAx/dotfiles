# Usage
#   ,edit <directory> [<vim-args>]
#   ,edit <file>
#
# When passing a directory, the directory will be opened in neovim and the
# last session of this directory will be loaded. When passing additional
# <vim-args>, they are passed to nvim. This can be used to specify a file
# that should be opened by default when no session exists.
#
# When passing in a file as first argument, the file will be opened and no
# session will be loaded.
,edit() {
    if [[ ! -d "$1" ]]; then
        vim "$@"
        return
    fi

    pushd "$1" >/dev/null
    shift
    nvim -c "lua require'persistence'.load(); vim.cmd('Neotree show')" "$@"
    popd >/dev/null
}

_editor=nvim

alias ,=",edit ~/.shellrc.d/config-aliases.sh"

# Bspwm
alias ,bspwm=",edit ~/.config/bspwm bspwmrc"
alias ,sxhkd=",edit ~/.config/sxhkd sxhkdrc"
alias ,polybar=",edit ~/.config/polybar config"
alias ,picom=",edit ~/.config/picom picom.conf"

# Hyprland
alias ,hyprland=",edit ~/.config/hypr hyprland.conf"
alias ,eww=",edit ~/.config/eww eww.yuck"

# Others
alias ,nvim=",edit ~/.config/nvim"
alias ,home-manager=",edit ~/.config/home-manager home.nix"
alias ,flatpak-aliases=",edit ~/.shellrc.d/flatpak-aliases.sh"
alias ,nixos="sudo $_editor -c 'cd /etc/nixos/' /etc/nixos/current-host/configuration.nix"
alias ,autostart=",edit ~/.local/scripts autostart.sh"

# Others
alias ,nvim="$_editor -c 'cd ~/.config/nvim' ~/.config/nvim"
alias ,home-manager="$_editor -c 'cd ~/.config/home-manager/' ~/.config/home-manager/flake.nix"
alias ,yazi="$_editor -c 'cd ~/.config/yazi/' ~/.config/yazi/yazi.toml"

unset _editor
