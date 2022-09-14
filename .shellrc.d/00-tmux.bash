#parent="$(ps -o args= | head -n1)"
if command -v tmux &> /dev/null && [ -z $KITTY_INSTALLATION_DIR ] && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
    function tmux-loop() {
        timeout=5

        tmux new

        gray="\e[38m"
        green="\e[32m"
        red="\e[31m"
        blue="\e[34m"
        default="\e[m"
        yellow="\e[33m"

        tmux_loop=true
        while $tmux_loop; do
            x=''

            clear
            echo >&2 ""
            echo >&2 -e "  ${green}INSERT COIN TO CONTINUE!${default}"
            echo >&2 -e "${gray}"
            echo >&2 -e "    Space :   Start new tmux session"
            echo >&2 -e "    Enter :   Connect to an existing session (or create new one if none exists)"
            echo >&2 -e "    X     :   Fall back to bash"
            echo >&2 -e "    Q     :   Give up (ProTip: Ctrl+D also works)"
            echo >&2 -e "${default}"

            for (( i=$timeout; i>=0; i-- )); do
                if [[ $i == 0 ]]; then
                    # Time is up
                    echo >&2 -e "\r  ${red}--- GAME OVER ---${default}"
                    sleep 0.5
                    exit
                fi

                echo >&2 -ne "\r  ${yellow}Time left: ${i}s ${default}"
                read -N 1 -t 1 -s x
                e=$?

                # From the `read` manual: "The exit status is greater than 128 if the timeout is exceeded"
                if [[ $e -gt 128 ]] ; then
                    continue
                fi

                # Value of $x is 0x04 when Ctrl+D is pressed which can be expressed as $'\04' in bash
                if [[ $x == $'\04' ]] || [[ $x =~ ^(q|Q)$ ]]; then
                    exit
                fi

                if [[ $x == $'\n' ]]; then
                    tmux attach || tmux new
                    break
                fi

                if [[ $x == ' ' ]]; then
                    tmux new
                    break
                fi

                if [[ $x =~ ^(x|X)$ ]]; then
                    echo >&2 -e "\n\nStarting bash...\n"
                    tmux_loop=false
                    break
                fi

                if [[ $e -ne 0 ]]; then
                    echo >&2 -e "\ntmux.bash: Something bad happened: \`read\` exited with an unexpected exit code '${e}'. Falling back to bash...\n"
                    tmux_loop=false
                    break
                fi

                # Another key was pressed. Give user another second
                let i++
            done
        done

    }

    tmux-loop
fi
