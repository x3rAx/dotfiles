#!/usr/bin/env bash

src_id="$1"
dest_id="$2"

if [[ -z $dest_id ]]; then
    dest_id="$(tmux display -p '#{session_id}')"
fi

echo "$src_id $dest_id"
#tmux switch-client -t $src_id
#exit
#
##tmux switch-client -t "$dest"
#for w in $(tmux list-windows -F '#{window_id}' -t "$src_id"); do
#    tmux move-window -a -s "$w" -t "$dest"
#done
#
##bind C-m run-shell "tmux run-shell 'echo \'#{session_name}\''"
##name=\"\$(echo '%%' | cut -d: -f1):\" \;\
#    #seq #{session_windows} | xargs -I{} tmux move-window -t \"\${name}\" ;\
