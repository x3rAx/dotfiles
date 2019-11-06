# exports

#export ANDROID_HOME="/opt/android-sdk/"
export ANDROID_HOME="$HOME/.local/opt/android/sdk/"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export EDITOR=nvim
export MAKEFLAGS='-j12'
export SSHT_SESSION_NAME='x3ro'
export TERMINAL=urxvt
#export TERMINAL_CMD='gnome-terminal --'
export TERMINAL_CMD='urxvt -e'

# Fix nvim-gtk theme
export NVIM_GTK_DOUBLE_BUFFER=1

#export TERM=xterm-256color

# This does not fix the nvim problem (IT WRITES AN EMPTY FILE!!!)
#export SUDO_ASKPASS="$HOME/.local/bin/askpass-rofi"
