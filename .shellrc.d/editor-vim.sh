if command -v nvim >/dev/null; then
    EDITOR=nvim
elif command -v vim >/dev/null; then
    EDITOR=vim
else
    echo >&2 -n '[WARN] `nvim`/`vim` not found. Falling back to '
    if command -v vi >/dev/null; then
        echo >&2 '`vi`'
        EDITOR=vi
    elif command -v nano >/dev/null; then
        echo >&2 '`nano`'
        EDITOR=nano
    else
        echo >&2 'NOTHING'
    fi
fi 

export EDITOR
