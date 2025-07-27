#!/bin/bash

FIXTURE_NAME="sweep_command"
source "$TEST_ROOT/base.sh"
echo "${BRUSH_CYAN}RUN_TEST${BRUSH_CLEAR}: $FIXTURE_NAME"

# verify api can load
brush_defined sweep_command
brush_assert $? $FIXTURE_NAME "sweep_command_defined"

# positive case
sweep_command cat
brush_assert $? $FIXTURE_NAME "sweep_command_when_command_defined"

catch_exit_when_command_undefined() {
  (
    sweep_command command_does_not_exits 2> /dev/null
    return 0
  ) # capture the exit
  test $? -eq 1
  return $?
}

# negative case
catch_exit_when_command_undefined
brush_assert $? $FIXTURE_NAME "sweep_command_when_command_undefined"
