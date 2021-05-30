# Setup fzf
# ---------
if [[ ! "$PATH" == */home/x3ro/.local/subrepos/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/x3ro/.local/subrepos/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/x3ro/.local/subrepos/fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/x3ro/.local/subrepos/fzf/shell/key-bindings.bash"
