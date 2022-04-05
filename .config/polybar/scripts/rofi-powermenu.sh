#!/usr/bin/env bash

# More safety by turning bugs into errors.
# Use `${PIPESTATUS[n]}` to check for the `n`-th pipe command's exit status.
# Make sure there are no uninitialized variables.
# To allow a non-zero exit status or to allow a pipe to fail without exiting
# the script, prefix the command with `!`.
# Option `noclobber` makes sure piping into a file with `>` does not
# override existing files. Use `>|` to overwrite files instead.
# Environment variables are `UPPER_SNAKE_CASE`, global constants are
# `_UNDERSCORE_PREFIXED` and global variables are `_underscore_prefixed`
set -o errexit -o pipefail -o nounset -o noclobber

: ${XDG_CONFIG_HOME:=$HOME/.config}
: ${XDG_CACHE_HOME:=$HOME/.cache}

readonly _SCRIPT="$(realpath "$0")"
readonly _SCRIPT_NAME="${_SCRIPT##*/}"
readonly _SCRIPT_DIR="${_SCRIPT%/*}"

err() { echo >&2 "${_SCRIPT_NAME}: $@"; }

readonly _ERR_USAGE=2
readonly _ERR_PROGRAMMING=255

readonly _USAGE="
  Usage:
    $_SCRIPT_NAME <options> <arguments>

  OPTIONS:
    -h, --help              Show this help message.
    -m, --mouse             Place window relative to mouse cursor
    -t, --top <pixels>      Show the menu at minimum <pixels> pixels from the
                            top border of the screen.
    -r, --right <pixels>    Show the menu at minimum <pixels> pixels from the
                            right border of the screen.
    -b, --bottom <pixels>   Show the menu at minimum <pixels> pixels from the
                            bottom border of the screen.
    -l, --left <pixels>     Show the menu at minimum <pixels> pixels from the
                            left border of the screen.
"

readonly _OPTIONS='hmt:r:b:l:'
readonly _LONGOPTS='help,mouse,top:,right:,bottom:,left:'

parsed="$(getopt -o "$_OPTIONS" -l "$_LONGOPTS" -n "$_SCRIPT_NAME" -- "$@")"
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then echo >&2 "$_USAGE"; exit $_ERR_USAGE; fi
eval set -- "${parsed[@]}"; unset parsed

_mouse=false
_top=0
_bottom=0
_left=0
_right=0

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)      echo "$_USAGE"; exit; ;;
        -m|--mouse)     _mouse=true; shift; ;;
        -t|--top)       _top="$2"; shift 2; ;;
        -r|--right)     _right="$2"; shift 2; ;;
        -b|--bottom)    _bottom="$2"; shift 2; ;;
        -l|--left)      _left="$2"; shift 2; ;;
        --)             shift; break; ;;
        *)              err "Programming error"; exit $_ERR_PROGRAMMING; ;;
    esac
done

# --- main program -------------------------------------------------------------

readonly _S_CANCEL='Cancel'
readonly _S_REBOOT='Reboot'
readonly _S_POWEROFF='Power Off'
readonly _S_HIBERNATE='Hibernate'
readonly _S_SUSPEND='Suspend (Sleep)'

readonly _ROFI_THEME="${_SCRIPT}.theme"

eval "$(xdotool getmouselocation --shell | xargs -i{} echo '_MOUSE_{}')"
eval "$(xdotool getdisplaygeometry --shell | xargs -i{} echo '_DISPLAY_{}')"

_window_width=300
_window_height=200
_window_x="$(( _MOUSE_X - ( _window_width / 2 ) ))"
_window_y="$_MOUSE_Y"

if (( _window_x < $_left )); then _window_x=$_left; fi
if (( _window_x + _window_width + _right > _DISPLAY_WIDTH )); then
    _window_x=$(( _DISPLAY_WIDTH - _window_width - _right )); fi
if (( _window_y < _top )); then _window_y=$_top; fi
if (( _window_y + _window_height + _bottom > _DISPLAY_HEIGHT )); then
    _window_y=$(( _DISPLAY_HEIGHT - _window_height - _bottom )); fi

rofimenu() {
    local window_pos=''
    local monitor_opt=''
    if [[ $_mouse == true ]]; then
        window_pos="
            location: north west;
            x-offset: ${_window_x}px;
            y-offset: ${_window_y}px;
        "
        monitor_opt='-monitor primary'
    fi
    rofi -dmenu -i \
        -hover-select \
        -me-select-entry '' \
        -me-accept-entry 'MousePrimary' \
        -theme "$_ROFI_THEME" \
        -theme-str "
            window {
                width: ${_window_width}px;
                height: ${_window_height}px;
                ${window_pos}
            }
        " \
        $monitor_opt \
        "$@"
}

selection="$(echo "\
${_S_CANCEL}
${_S_SUSPEND}
${_S_HIBERNATE}
${_S_REBOOT}
${_S_POWEROFF}" \
    | rofimenu -p '')"

if [[ $selection == $_S_CANCEL ]] || [[ $selection == '' ]]; then
    exit
fi

sleep 0.125 # Short delay to prevent next menu from crashing because previous menu still exists
! confirmation="$(echo $'yes\nno' | rofimenu -p "${selection}?")"
if [[ $confirmation != yes ]]; then
    exit
fi

case $selection in
    "$_S_REBOOT")    systemctl reboot; ;;
    "$_S_POWEROFF")  systemctl poweroff; ;;
    "$_S_HIBERNATE") systemctl hibernate; ;;
    "$_S_SUSPEND")   systemctl suspend; ;;
    *)
        err "Invalid option: ${selection}";
        notify-send "rofimenu: Invalid option ${selection}";
        exit 1; ;;
esac