#!/bin/bash
# shellcheck disable=SC2319

FIXTURE_NAME="sweep_sudo"
source "$TEST_ROOT/base.sh"
echo "${BRUSH_CYAN}RUN_TEST${BRUSH_CLEAR}: $FIXTURE_NAME"

# verify api can load and argument guard
brush_defined sweep_sudo
brush_assert $? $FIXTURE_NAME "sweep_sudo_defined"

# verify cases when not root
(
  sweep_sudo error
  return 0
) # capture the exit
test $? -eq 1
brush_assert $? $FIXTURE_NAME "sweep_sudo_argument_validity_error"

(
  sweep_sudo
  return 0
) # capture the exit
test $? -eq 1
brush_assert $? $FIXTURE_NAME "sweep_sudo_exit_when_not_root_but_should_implicit"

(
  sweep_sudo true
  return 0
) # capture the exit
test $? -eq 1
brush_assert $? $FIXTURE_NAME "sweep_sudo_exit_when_not_root_but_should_explicit"

sweep_sudo false
brush_assert $? $FIXTURE_NAME "sweep_sudo_return_when_not_root_and_should_not"

return 0
