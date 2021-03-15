if [ "$(command -v exa)" ]; then
    unalias 'll' 2>/dev/null
    unalias 'l'  2>/dev/null
    unalias 'la' 2>/dev/null
    unalias 'ls' 2>/dev/null

    alias ls='exa -G --color auto --icons -a -s type'
    alias ll='exa -l --color always --icons -s type'
    alias la='exa -l --color always --icons -a -s type'
fi