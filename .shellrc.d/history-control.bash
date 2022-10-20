# `ignorespace` - Ignore lines that start with a space
# `ignoredups`  - Ignore duplicate commands
# `ignoreboth`  - Same as `ignorespace:ignoredups`
# `erasedups`   - Erase all duplicates in the whole history that match current line
HISTCONTROL=ignoreboth

HISTSIZE=5000000
HISTFILESIZE="$HISTSIZE"

# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
HISTFILE=~/.bash_history_long
