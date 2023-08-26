_editor=nvim

alias ,="$_editor ~/.shellrc.d/config-aliases.sh"

# Bspwm
alias ,bspwm="$_editor ~/.config/bspwm/bspwmrc +':cd %:h'"
alias ,sxhkd="$_editor ~/.config/sxhkd/sxhkdrc +':cd %:h'"
alias ,polybar="$_editor ~/.config/polybar/config +':cd %:h'"

# Hyprland
alias ,hyprland="$_editor -c 'cd ~/.config/hypr' ~/.config/hypr/hyprland.conf"
alias ,eww="$_editor -c 'cd ~/.config/eww' ~/.config/eww/eww.yuck"
alias ,nix="$_editor -c 'cd /etc/nixos' /etc/nixos/current-host/configuration.nix"
alias ,autostart="$_editor -c 'cd ~/.local/scripts' ~/.local/scripts/autostart.sh"

unset _editor
