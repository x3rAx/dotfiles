if [ -d "$HOME/.bookmarks" ]; then
    goto() {
        local USAGE="
  Usage:
    goto <bookmark>
    goto -l
    goto -s[r|a][f] <bookmark> [path]
    goto -d <bookmark>
"

        local bookmarks="$HOME/.bookmarks"

        if [[ $# == 0 ]]; then
            echo >&2 "$USAGE"
            return 1
        fi
        if [[ $1 =~ ^(-h|--help)$ ]]; then
            echo "$USAGE"
            return
        fi

        if [[ $1 == '-l' ]]; then
            for l in $(find "$bookmarks" -type l -printf '%f\n'); do
                t="$(readlink "$bookmarks/$l")"
                relAbs="rel"
                if [[ $t =~ ^/ ]]; then
                    relAbs="abs"
                else
                    t="$(realpath -s "$bookmarks/$t")"
                fi
                t="${t/#$HOME/\~}"
                echo -e "$l\t-> $t\t"[$relAbs] 
            done | column -t -s $'\t'
            return
        fi

        if [[ $1 =~ ^-s(r|a|)(f|)$ ]]; then
            local name="$2"
            local target_abs="$(realpath -s "${3:-.}")"
            local target="$(realpath -s --relative-to="$bookmarks" "$target_abs")"
            local relAbs="rel"
            local force=""

            if [[ $name =~ [[:space:]]|/ ]]; then
                echo >&2 "ERROR: Name contains illegal characters: Whitespaces and slashes are not allowed"
                return 1
            fi

            if [[ $1 =~ a ]]; then
                target="$target_abs"
                relAbs="abs"
            fi
            if [[ $1 =~ f ]]; then
                force="-f"
            fi

            ln -s $force -T "$target" "$bookmarks/$name"
            echo >&2 "Saved: $name -> $target_abs/  [$relAbs]"
            return
        elif [[ $1 == '-d' ]]; then 
            local target="$(readlink "$HOME/.bookmarks/$2")"
            local relAbs="rel"
            if [[ $target =~ ^/ ]]; then
                relAbs="abs"
            else
                target="$bookmarks/$target"
                target="$(realpath -s "$target")"
            fi
            unlink "$bookmarks/$2"
            echo >&2 "Deleted: $2 -> $target/  [$relAbs]"
            return
        elif [[ $1 =~ ^- ]]; then
            echo >&2 "ERROR: Unknown flag: $1"
            return 1
        fi
        l="$(readlink "$HOME/.bookmarks/$@")"
        if [[ $l =~ ^/ ]]; then
            cd "$l"
        else
            cd "$HOME/.bookmarks/$l"
        fi
    }
    _goto() {
        compopt +o default # Disable default completion

        local cword="$COMP_CWORD"
        local words=( "${COMP_WORDS[@]}" )
        local word="${words[cword]}"
        local line=${COMP_LINE}
        local bookmarks="$HOME/.bookmarks"
        
        local origIFS="$IFS"
        #local IFS=$'\n'
        local comp_bookmarks=( $( compgen -W "$(\ls "$HOME/.bookmarks")" -- "$word" ) )
        # Escape names
        local item i
        i=0
        for item in "${comp_bookmarks[@]}"; do
            comp_bookmarks[$i]="$(printf '%q' "$item")"
            let 'i += 1'
        done

        COMPREPLY=()

        if [[ $cword == 1 ]]; then
            if [[ $word =~ ^- ]]; then
                COMPREPLY+=( $( compgen -W "-s -sr -sa -srf -saf -d" -- "$word" ) )
                return
            fi

            COMPREPLY+=( "${comp_bookmarks[@]}" )
        elif [[ $cword == 2 ]] && [[ ${words[1]} =~ ^- ]]; then
            COMPREPLY+=( "${comp_bookmarks[@]}" )
        elif [[ $cword == 3 ]] && [[ ${words[1]} =~ ^-s ]]; then
            compopt -o filenames
            COMPREPLY+=( $( compgen -d -- "$word" ) )
            #compopt -o default # Enable default completion
        fi
    #} && complete -F _goto goto
    }

    alias gd="goto"
    alias gto="goto"
    complete -F _goto goto
    complete -F _goto gd
    complete -F _goto gto

fi