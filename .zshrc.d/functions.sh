# .bash_functions

##
# Bash completion wrapper
#
# Usage:
#   make-completion-wrapper _apt_get _agi apt-get install
#   complete -o filenames -F _agi agi
#
# From: https://ubuntuforums.org/showthread.php?t=733397#post4573310
##
function make-completion-wrapper () {
    local function_name="$2"
    local arg_count=$(($#-3))
    local comp_function_name="$1"
    shift 2
    local function="
        function $function_name {
            ((COMP_CWORD+=$arg_count))
            COMP_WORDS=( "$@" \${COMP_WORDS[@]:1} )
            "$comp_function_name"
            return 0
        }"
    eval "$function"
    echo $function_name
    echo "$function"
}

## From: http://stackoverflow.com/a/20032857/1185892
##_completion_loader () {
##    local compfile=./completions;
##    [[ $BASH_SOURCE == */* ]] && compfile="${BASH_SOURCE%/*}/completions";
##    compfile+="/${1##*/}";
##    [[ -f "$compfile" ]] && . "$compfile" &> /dev/null && return 124;
##    complete -F _minimal "$1" && return 124
##}
#
## SSH with tmux
#ssht() {
#    local user="$(whoami)"
#    local host="$(hostname)"
#    local defaultSessionName="${SSHT_SESSION_NAME:-"${user}@${host}"}"
#    local sessionName="${@: -1}" # Get last argument
#
#    if [[ ${sessionName:0:1} == ':' ]]; then
#        #shift # Remove first argument
#        set -- "${@:1:$(($#-1))}"      # Remove last argument
#        sessionName=${sessionName#":"} # Remove leading colon
#    else
#        sessionName="$defaultSessionName"
#    fi
#
#    ssh $@ -t "tmux a -t '${sessionName}' || tmux new -s '${sessionName}'"
#
##    if [[ -f ~/.ssht-tmux.conf ]]; then
##        tmuxFile="-f <(cat <<EOF
##$(cat ~/.ssht-tmux.conf)
##EOF
##)"
##    fi
##
##   ssh $@ -t "tmux a -t ${sessionName} ${tmuxFile} || tmux new -s ${sessionName} ${tmuxFile}"
#}
#complete -o default -o nospace -F _ssh ssht
#_completion_loader ssh

# xvim - create executables with vim
xvim() {
    local f="$@"
    local d="$(dirname $f)"
    if [[ ! -d "$d" ]]; then
        read inp\?"Directory \"$d\" doesn't exist. Create it? [Yn] "

	if [[ $inp == '' ]] || [[ ${inp,,} == 'y' ]]; then
            mkdir -p "$d"
        else
            return 1
        fi
    fi

    touch "$f" || return $?
    chmod +x "$f" || return $?
    vim "$f" || return $?
}

aliased() {
    local name="$1"
    local alias="$(alias "$1")"

    if [[ -z $alias ]]; then
        exit 1
    fi

    echo "$alias" \
        | sed -e "s/^[^=]*='\(.*\)'$/\1/"
}
