#declare -A TRUELINE_COLORS=(
#    [light_blue]='75;161;207'
#    [grey]='99;99;100'
#    [pink]='199;88;157'
#)
#
#declare -a TRUELINE_SEGMENTS=(
#    'working_dir,light_blue,black,normal'
#    'git,grey,black,normal'
#    'time,white,black,normal'
#    'newline,pink,black,bold'
#)
#
#declare -A TRUELINE_SYMBOLS=(
#    [git_modified]='*'
#    [git_github]=''
#    [segment_separator]=''
#    [working_dir_folder]='...'
#    [working_dir_separator]='/'
#    [working_dir_home]='~'
#    [newline]='❯'
#    [clock]='🕒'
#)
#
#TRUELINE_GIT_SHOW_STATUS_NUMBERS=false
#TRUELINE_GIT_MODIFIED_COLOR='grey'
#TRUELINE_WORKING_DIR_SPACE_BETWEEN_PATH_SEPARATOR=false

_trueline_time_segment() {
    local prompt_time="${TRUELINE_SYMBOLS[clock]} \t"
    if [[ -n "$prompt_time" ]]; then
        local fg_color="$1"
        local bg_color="$2"
        local font_style="$3"
        local segment="$(_trueline_separator)"
        segment+="$(_trueline_content "$fg_color" "$bg_color" "$font_style" " $prompt_time ")"
        PS1+="$segment"
        _last_color=$bg_color
    fi
}

_trueline_empty-line_segment() {
    PS1+="\n"
}

_trueline_fake-home_segment() {
    if [[ ! $HOME =~ /\.FAKE-HOME(|/.*)$ ]]; then
        return
    fi
    local fg_color="$1"
    local bg_color="$2"
    local font_style="$3"
    local prompt=" FAKE-HOME"
    local segment="$(_trueline_separator)"
    segment+="$(_trueline_content "$fg_color" "$bg_color" "$font_style" " $prompt")"
    PS1+="$segment"
    _last_color=$bg_color
}

declare -a TRUELINE_SEGMENTS=(
    "empty-line"
    "user,black,white,bold"
    "venv,black,purple,bold"
    "git,grey,special_grey,normal"
    "fake-home,red,cursor_grey,normal"
    "working_dir,mono,cursor_grey,normal"
    "read_only,black,orange,bold"
    "bg_jobs,black,orange,bold"
    "exit_status,black,red,bold"
)

source ~/.local/subrepos/trueline/trueline.sh
