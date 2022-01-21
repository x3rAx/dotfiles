# History Sync
################

# Append to history file instead of overwriting it
shopt -s histappend
# Append to history file after every command
PROMPT_COMMAND="history -a; $PROMPT_COMMAND" # Append to

# Sync history from file to session
alias history-sync='history -n'

# ALT-Shift-r - Sync history from file to session
bind -m emacs-standard '"\eR": " \C-b\C-k \C-u history-sync\e\C-e\er\C-m\C-y\C-h\e \C-y\ey\C-x\C-x\C-d"'
bind -m vi-command '"\eR": "\C-z\er\C-z"'
bind -m vi-insert '"\eR": "\C-z\er\C-z"'
