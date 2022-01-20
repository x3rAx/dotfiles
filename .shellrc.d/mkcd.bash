mkcd() {
    local USAGE="
Usage:
    mkcd [options] [--] <directory> [[directory]...]

Creates all given directories and \`cd\`s into the first one.

OPTIONS:
    -h, --help                 Print this help
    -o, --mkdir-opt \"opt\"      Pass a single option to \`mkdir\`. Can be
                               specified multiple times to pass more options to
                               \`mkdir\`
    -p, --parents              Shortcut for \`-o \"-p\"\`. No error if
                               existing, make parent directories as needed
    --                         Stop parsing and treat all following arguments
                               as directory names
"
    local dirs_arr=()
    local mkdir_opts=()
    local parse=true
    local arg
    local opt

    while [[ $# > 0 ]]; do
        arg="$1"
        shift

        if [[ $parse != true ]]; then
            dirs_arr+=("$arg")
            continue
        fi

        case $arg in
            '-h'|'--help')
                echo "$USAGE"
                return
                ;;
            '-p'|'--parents')
                mkdir_opts+=("$arg")
                ;;
            '-o='*|'--mkdir-opts='*)
                opt="${arg#*"="}"
                mkdir_opts+=("$opt")
                ;;
            '-o'|'--mkdir-opts')
                opt="$1"
                shift
                mkdir_opts+=("$opt")
                ;;
            '--')
                # Stop parsing args
                parse=false
                ;;
            '-'*)
                echo >&2 "Unknown option \`\$arg\`. If you want to pass options to \`mkdir\`, use the \`-o\` option."
                return 1
                ;;
            *)
                dirs_arr+=("$arg")
                ;;
        esac
    done

    mkdir "${mkdir_opts[@]}" "${dirs_arr[@]}" || return $?
    cd "${dirs_arr[0]}"
}
