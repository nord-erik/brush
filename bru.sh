#!/bin/env bash
BRUSH_APP_NAME=$1
BRUSH_DEFAULT_APP_NAME="bru.sh"
if [ -z "$BRUSH_APP_NAME" ];then
BRUSH_APP_NAME="$BRUSH_DEFAULT_APP_NAME"
fi
BRUSH_BLACK=$'\033[30m'
BRUSH_RED=$'\033[31m'
BRUSH_GREEN=$'\033[32m'
BRUSH_YELLOW=$'\033[33m'
BRUSH_BLUE=$'\033[34m'
BRUSH_MAGENTA=$'\033[35m'
BRUSH_CYAN=$'\033[36m'
BRUSH_WHITE=$'\033[37m'
BRUSH_LIGHT_BLACK=$'\033[90m'
BRUSH_LIGHT_RED=$'\033[91m'
BRUSH_LIGHT_GREEN=$'\033[92m'
BRUSH_LIGHT_YELLOW=$'\033[93m'
BRUSH_LIGHT_BLUE=$'\033[94m'
BRUSH_LIGHT_MAGENTA=$'\033[95m'
BRUSH_LIGHT_CYAN=$'\033[96m'
BRUSH_LIGHT_WHITE=$'\033[97m'
BRUSH_CLEAR=$'\033[0m'
_brush_system_logger(){
local prio=$1
local suffix=$2
local msg=$3
logger -t "$BRUSH_APP_NAME" -p "user.$prio" "[$$] $suffix $msg"
}
_brush_terminal_print(){
local colour=$1
local suffix=$2
local msg=$3
local to_stderr=$4
msg=$(printf "%b %s" "$colour$suffix$BRUSH_CLEAR" "$msg")
if test -z "$to_stderr";then
printf "%s\n" "$msg"
else
printf "%s\n" "$msg" >&2
fi
}
brush_error(){
local msg=$1
_brush_system_logger "err" "(ERROR)" "$msg"
_brush_terminal_print "$BRUSH_RED" "error:" "$msg" to_sderr_please
}
brush_warning(){
local msg=$1
_brush_system_logger "warn" "(WARNING)" "$msg"
_brush_terminal_print "$BRUSH_YELLOW" "warning:" "$msg"
}
brush_notice(){
local msg=$1
_brush_system_logger "notice" "(NOTICE)" "$msg"
_brush_terminal_print "$BRUSH_BLUE" "notice:" "$msg"
}
brush_log(){
local msg=$1
_brush_system_logger "info" "(INFO)" "$msg"
_brush_terminal_print "$BRUSH_WHITE" "info:" "$msg"
}
sweep_command(){
for cmd in "$@";do
command -v "$cmd" >/dev/null 2>&1
sweep_ok $? "required command '$cmd' not found"
done
}
sweep_env(){
local env_var_name=$1
test ${!env_var_name+1}
sweep_ok $? "required env variable '$env_var_name' is not set!"
}
sweep_nok(){
local code=$1
local msg=$2
local custom_error_code=$3
if [ -z "$custom_error_code" ];then
custom_error_code=1
fi
if [ $code -ne 1 ];then
if [ -n "$msg" ];then
brush_error "$msg"
fi
exit $custom_error_code
fi
}
sweep_ok(){
local code=$1
local msg=$2
local custom_error_code=$3
if [ -z "$custom_error_code" ];then
custom_error_code=1
fi
if [ $code -ne 0 ];then
if [ -n "$msg" ];then
brush_error "$msg"
fi
exit $custom_error_code
fi
}
sweep_sudo(){
local should_be=$1
local is_root final_app_name
if [ "$BRUSH_APP_NAME" = "$BRUSH_DEFAULT_APP_NAME" ];then
final_app_name="this script"
else
final_app_name="'$BRUSH_APP_NAME'"
fi
if [ -z "$should_be" ];then
should_be=true
fi
if [ "$should_be" = "true" ]||[ "$should_be" = "false" ];then
true
else
brush_error "sweep_sudo optional 1st argument must be omitted, true or false"
exit 1
fi
if [ "$(id -u)" -eq 0 ];then
is_root="true"
else
is_root="false"
fi
case $is_root in
true)if
[ "$should_be" = "true" ]
then
return 0
fi
brush_error "you must be user in order to run $final_app_name, please re-run without root"
;;
false)if
[ "$should_be" != "true" ]
then
return 0
fi
brush_error "you must be root in order to run $final_app_name, please re-run with sudo"
;;
*)brush_error "unexpected case of quantum root"
esac
exit 1
}
sweep_git_is_clean(){
local git_status current_dir
current_dir="$(pwd)"
sweep_git_is_init
git_status="$(git status --porcelain)"&&test -z "$git_status"
sweep_ok $? "expected git repo to be clean: $current_dir"
}
sweep_git_is_init(){
local is_init current_dir
current_dir="$(pwd)"
is_init="$(git rev-parse --is-inside-work-tree 2>/dev/null)"
test "$is_init" == true
sweep_ok $? "expected this to be a git repo: $current_dir"
}
sweep_git_is_on(){
local expected_branch=$1
local current_branch current_dir
test -z "$current_branch"
sweep_ok $? "you must pass an expected branch name to 'sweep_git_is_on'"
current_dir="$(pwd)"
sweep_git_is_init
current_branch="$(git rev-parse --abbrev-ref HEAD)"
test "$current_branch" == "$expected_branch"
sweep_ok $? "expected branch '$expected_branch' but was '$current_branch' in git: $current_dir"
}
export BRUSH_APP_NAME BRUSH_DEFAULT_APP_NAME BRUSH_BLACK BRUSH_RED BRUSH_GREEN BRUSH_YELLOW BRUSH_BLUE BRUSH_MAGENTA BRUSH_CYAN BRUSH_WHITE BRUSH_LIGHT_BLACK BRUSH_LIGHT_RED BRUSH_LIGHT_GREEN BRUSH_LIGHT_YELLOW BRUSH_LIGHT_BLUE BRUSH_LIGHT_MAGENTA BRUSH_LIGHT_CYAN BRUSH_LIGHT_WHITE BRUSH_CLEAR
