# pip-local

export PYTHONUSERBASE=~/.pip-local

export PATH="${PYTHONUSERBASE}/bin:$PATH"

if [[ ! -d $PYTHONUSERBASE ]]; then
    echo "Creating local pip directory '$PYTHONUSERBASE'."
    mkdir -p "$PYTHONUSERBASE"
fi

pip() {
    local pip="$(command -vp pip)"

    if [[ -z $pip ]]; then
        echo >&2 "ERROR: pip-local: Cannot find \`pip\`."
        return 1
    fi

    echo >&2 '--- pip-local ---'

    if [ "$1" = "install" -o "$1" = "bundle" ]; then
        cmd="$1"
        shift
        $pip $cmd --user $@
    else
        $pip $@
    fi
}

