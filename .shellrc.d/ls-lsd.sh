if [ "$(command -v lsd)" ]; then
    unalias 'll' 2>/dev/null
    unalias 'l'  2>/dev/null
    unalias 'la' 2>/dev/null
    unalias 'ls' 2>/dev/null

    alias ls='lsd --hyperlink=auto -A --group-directories-first'
    alias ll='lsd --hyperlink=auto -l --group-directories-first'
    alias la='lsd --hyperlink=auto -lA --group-directories-first'
fi