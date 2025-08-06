#!/bin/env bash

# this script contains logging utilities that can be used by anyone really
# functions prefixed "_" are not meant to be used directly, but who can stop you

_brush_system_logger() {
    local prio=$1 suffix=$2 msg=$3

    logger -t "$BRUSH_APP_NAME" -p "user.$prio" "[$$] $suffix $msg"
}

_brush_terminal_print() {
    local colour=$1 suffix=$2 msg=$3 to_stderr=$4
    msg=$(printf "%b %s" "$colour$suffix$BRUSH_CLEAR" "$msg")

    if test -z "$to_stderr"; then
        printf "%s\n" "$msg"
    else
        printf "%s\n" "$msg" >&2
    fi
}

# prints a visual error and logs it
brush_error() {
    local msg=$1

    _brush_system_logger "err" "(ERROR)" "$msg"
    _brush_terminal_print "$BRUSH_RED" "error:" "$msg" to_sderr_please
}

# prints a visual warning and logs it
brush_warning() {
    local msg=$1

    _brush_system_logger "warn" "(WARNING)" "$msg"
    _brush_terminal_print "$BRUSH_YELLOW" "warning:" "$msg"
}

# prints a visual notice and logs it
brush_notice() {
    local msg=$1

    _brush_system_logger "notice" "(NOTICE)" "$msg"
    _brush_terminal_print "$BRUSH_BLUE" "notice:" "$msg"
}

# prints a visual message and logs it
brush_log() {
    local msg=$1

    _brush_system_logger "info" "(INFO)" "$msg"
    _brush_terminal_print "$BRUSH_WHITE" "info:" "$msg"
}
