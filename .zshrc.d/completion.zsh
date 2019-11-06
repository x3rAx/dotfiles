# zsh completion

fpath=(~/.zshrc.d/completion $fpath)

autoload -U compinit
compinit

zstyle ':completion:*' menu select=2
