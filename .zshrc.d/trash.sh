# trash.sh

# This requires `trash-cli` to be installed.

alias rm="echo 'Use \`\\\\rm\` if you really want to use rm!'; :"
alias rmrm="\\rm"
#alias rt="rmtrash"
#alias rt="trash -v"
alias trl="trash-list"
alias trr="trash-restore"

rt() {
    local log="/tmp/x3ro-trash-rt.log"
    touch "$log"
    trash -v "$@" 2>&1 \
        | while read line; do
            echo "$line" >>"$log"
            if [[ $line =~ ^trash:\ \(Volume\ of\ file:\|Trash-dir:\) ]] then;
                continue;
            fi;

            if [[ ! $line =~ ^trash:\ \'\(.*\)\'\ trashed\ in ]]; then
                echo $line >&2
                continue
            fi

            echo "$line" | sed -e "s/^trash: '\(.*\)' trashed in \(.*\)$/\1\t-> \2/g"

            #IFS=$'\n' match=( $(echo "$line" | sed -e "s/^trash: '\(.*\)' trashed in \(.*\)$/\1\n\2/g") )

            #file="${match[1]}"
            #trash="${match[2]}"

            #length="${#file}"
            #echo $length

            #let spaces="4 - (${#file} % 4)"
            #echo $spaces
            #let spaces="spaces + 2"
            #echo $spaces
            #echo -n "$file"

            #for (( i=0 ; i<spaces; i++ )); do
            #    echo -n " "
            #done

            #echo "-> $trash"
        done
}
#trash: Volume of file: /home
#trash: Trash-dir: /home/x3ro/.local/share/Trash from volume: /home
#trash: 'trashme' trashed in ~/.local/share/Trash
