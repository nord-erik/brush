#!/bin/env bash

FIXTURE_NAME="sweep_command"
printf "%s\n" "${BRUSH_CYAN}RUN_TEST${BRUSH_CLEAR}: $FIXTURE_NAME"

# verify api can load
brush_defined sweep_command
brush_assert $? $FIXTURE_NAME "sweep_command_defined"

# positive case
sweep_command shellcheck
brush_assert $? $FIXTURE_NAME "sweep_command_when_command_defined"

# negative case
(
  sweep_command command_does_not_exits 2> /dev/null
  return 0
) # capture the exit
test $? -eq 1
brush_assert $? $FIXTURE_NAME "sweep_command_when_command_undefined"

# positive case multi arg
sweep_command shellcheck shfmt git
brush_assert $? $FIXTURE_NAME "sweep_commands_when_commands_defined"

# negative case multi arg
(
  sweep_command shellcheck shfmt git command_does_not_exits 2> /dev/null
  return 0
) # capture the exit
test $? -eq 1
brush_assert $? $FIXTURE_NAME "sweep_commands_when_some_undefined"

return 0
