# $HOME/.profile

#Set our umask
umask 022

# Set our default path
PATH="/usr/local/sbin:/usr/local/bin:/usr/bin/core_perl:/usr/bin:$HOME/.config/bspwm/panel:$HOME/.bin"
export PANEL_FIFO="/tmp/panel-fifo"
export PATH
export XDG_CONFIG_HOME="$HOME/.config"
export BSPWM_SOCKET="/tmp/bspwm-socket"
export PANEL_HEIGHT=25
export XDG_CONFIG_DIRS=/usr/etc/xdg:/etc/xdg
#export GUI_EDITOR=/usr/bin/micro-st
#export BROWSER=/usr/bin/firefox
#export BROWSER=/usr/bin/opera
export TERMINAL=/usr/bin/sterminal
export GUI_EDITOR="\"${TERMINAL}\" -e nvim"
export QT_QPA_PLATFORMTHEME="qt5ct"
#export EDITOR=/usr/bin/micro
export EDITOR=/usr/bin/nvim
export VISUAL=/usr/bin/nvim
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

export SSH_ASKPASS=/usr/lib/seahorse/ssh-askpass

# Load profiles from /etc/profile.d
if test -d /etc/profile.d/; then
	for profile in /etc/profile.d/*.sh; do
		test -r "$profile" && . "$profile"
	done
	unset profile
fi

# Source global bash config
if test "$PS1" && test "$BASH" && test -r /etc/bash.bashrc; then
	. /etc/bash.bashrc
fi

# Termcap is outdated, old, and crusty, kill it.
unset TERMCAP

# Man is much better than us at figuring this out
unset MANPATH


# Fix HIDPI Scaling
xrandr --dpi 192
export GDK_SCALE=2
export GDK_DPI_SCALE=0.9 # -> 2*0.9 = 1.8
#export QT_AUTO_SCREEN_SCALE_FACTOR=0
#export QT_SCALE_FACTOR=1.8
export QT_SCALE_FACTOR=1
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export QT_SCREEN_SCALE_FACTORS="1.8;1"

export MAKEFLAGS='-j10'

[[ -d $HOME/.local/bin ]] && export PATH="${HOME}/.local/bin:${PATH}"
#env >/tmp/envx.txt

