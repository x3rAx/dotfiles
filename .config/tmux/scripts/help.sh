#!/usr/bin/env bash

case "$1" in
    m) tmux new-window -t 0 -n 'TMUX' 'man tmux' 2>&1 || true;;
    k) tmux list-keys -N ;;
    K) tmux list-keys ;;
    *) echo "ERROR: Unbound key \"$1\""
esac
