# vagrant.sh

__VAGRANT_ORIGINAL="${__VAGRANT_ORIGINAL:-$(which vagrant)}"

mpo() {
    cd ~/Projects/CPL/MPO

    if [[ -z $@ ]]; then
        return
    fi

    if [[ $1 == 'config' ]]; then
        vim ../../vagrant_config
        return
    fi

    vagrant "$@"
}

VM() {
    cd ~/Projects/CPL/VM

    if [[ -z $@ ]]; then
        return
    fi

    vagrant "$@"
}

VM-DEV() {
    cd ~/Projects/CPL/VM-DEV

    if [[ -z $@ ]]; then
        return
    fi

    vagrant "$@"
}



function vagrant() {
    local args=()
    local inp

    local c_highlight="\e[92m"
    local c_err="\e[91m"
    local c_default="\e[39m"

    if [[ ${#} == 0 ]] || [[ $1 =~ ^-h\|--help$ ]]; then
        echo "
  Usage:
    vagrant <arg-list> [, [arg-list] [, [arg-list] [...]]]
    vagrant <arg-list>[, [arg-list][, [arg-list] [...]]]

  To view vagrant help use \`vagrant help\`.

  Call vagrant multiple times for each arg-list. Arg-lists are separated with
  comma \",\" either as a signgle argument: \`vagrant up , ssh\` or at the end
  of an arg-list: \`vagrant up, ssh\`
"
        return
    fi

    for arg in "$@"; do
        if [[ $arg == ',' ]] || [[ $arg =~ ^.*,$ ]]; then
            if [[ $arg =~ ^.*,$ ]]; then
                args+=("${arg%,}") # Strip last comma
            fi

            __call_vagrant "${args[@]}" ; e=$?

            if [[ $e > 0 ]]; then
                echo    "$c_err" >&2
                echo    ":: The command" >&2
                echo    "::    ${c_highlight}vagrant ${args[@]}${c_err}" >&2
                echo    ":: failed with exit code: ${e}" >&2
                echo    "::" >&2

                inp=""
                while [[ ! $inp =~ ^[yYnN]$ ]]; do
                    echo -n "$c_err" >&2
                    echo -n ":: Do you want to continue? [yN] " >&2
                    echo -n "$c_default" >&2

                    read inp
                    inp="${inp:-N}"

                    if [[ $inp =~ ^[nN]$ ]]; then
                        return $e
                    fi
                done
            fi

            args=()
            continue
        fi

        args+=( "$arg" )
    done

    if [[ -n ${args[@]} ]]; then
        __call_vagrant "${args[@]}" || return $?
    fi
}

__call_vagrant() {
    local args=("$@")
    local c_highlight="\e[92m"
    local c_err="\e[91m"
    local c_default="\e[39m"
    local msg=":: vagrant ${args[@]} ::"
    #local line="$(echo "$msg" | sed -e 's/./:/g')"

    echo -n "${c_highlight}"
    #echo "${line}"
    echo "${msg}"
    #echo "${line}"
    echo -n "${c_default}"
    "$__VAGRANT_ORIGINAL" "${args[@]}" || return $?
}
