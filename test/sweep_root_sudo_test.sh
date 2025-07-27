#!/bin/bash
# shellcheck disable=SC2319

# this file contains shenanigans to spawn child processes with sudo rights
# in order to properly function, all required funcs in the call stack of sweep_root has to be declared
# e.g. all logging and error printing wrappers, and sweep_root itself
#
# this test fixture is skipped if there are no cached sudo credentials

FIXTURE_NAME="sweep_root_sudo"
source "$TEST_ROOT/base.sh"
echo "${BRUSH_CYAN}RUN_TEST${BRUSH_CLEAR}: $FIXTURE_NAME"

# verify cases when is root
# returns 0 if there are cached sudo credentials and can sudo without user intervention...
can_sudo() {
  sudo -nv 2> /dev/null
  return $?
}

if can_sudo; then
  # pass along brush_error and sweep_root to child process
  (
    sudo bash -c "\
      $(declare -f __brush_system_logger);\
      $(declare -f __brush_terminal_print);\
      $(declare -f brush_error);\
      $(declare -f sweep_root);\
      sweep_root\
    "
  ) # capture the exit
  brush_assert $? $FIXTURE_NAME "sweep_root_returns_when_is_root"
else
  brush_skip $FIXTURE_NAME "sweep_root_returns_when_is_root"
fi

if can_sudo; then
  # pass along brush_error and sweep_root to child process
  (
    sudo bash -c "\
      $(declare -f __brush_system_logger);\
      $(declare -f __brush_terminal_print);\
      $(declare -f brush_error);\
      $(declare -f sweep_root);\
      sweep_root false\
    "
    return $?
  ) # capture the exit
  test $? -eq 1
  brush_assert $? $FIXTURE_NAME "sweep_root_exits_when_is_root_but_should_not"
else
  brush_skip $FIXTURE_NAME "sweep_root_exits_when_is_root_but_should_not"
fi
