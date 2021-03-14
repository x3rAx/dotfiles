# `~/.bash_profile`: executed by bash for login shells.
#
# A login shell is either a shell startet by ssh or when logging in from a
# linux terminal (Ctrl+Alt+[1-..]
#
# See https://stackoverflow.com/a/9954208/1185892 for a rough idea of how
# things are / should be sourced.
#
# See /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

[[ -r ~/.profile ]] && . ~/.profile
[[ -r ~/.bashrc ]] && . ~/.bashrc
