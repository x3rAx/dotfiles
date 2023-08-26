_editor=nvim

alias ,="$_editor ~/.shellrc.d/config-aliases.sh"
alias ,hyprland="$_editor -c 'cd ~/.config/hypr' ~/.config/hypr/hyprland.conf"
alias ,eww="$_editor -c 'cd ~/.config/eww' ~/.config/eww/eww.yuck"
alias ,nix="$_editor -c 'cd /etc/nixos' /etc/nixos/current-host/configuration.nix"
alias ,autostart="$_editor -c 'cd ~/.local/scripts' ~/.local/scripts/autostart.sh"

unset _editor
