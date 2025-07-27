#!/bin/bash
# shellcheck disable=SC2319

FIXTURE_NAME="sweep_root"
source "$TEST_ROOT/base.sh"
echo "${BRUSH_CYAN}RUN_TEST${BRUSH_CLEAR}: $FIXTURE_NAME"

# verify api can load and argument guard
brush_defined sweep_root
brush_assert $? $FIXTURE_NAME "sweep_root_defined"

# verify cases when not root
(
  sweep_root error
  return 0
) # capture the exit
test $? -eq 1
brush_assert $? $FIXTURE_NAME "sweep_root_argument_validity_error"

(
  sweep_root
  return 0
) # capture the exit
test $? -eq 1
brush_assert $? $FIXTURE_NAME "sweep_root_exit_when_not_root_but_should_implicit"

(
  sweep_root true
  return 0
) # capture the exit
test $? -eq 1
brush_assert $? $FIXTURE_NAME "sweep_root_exit_when_not_root_but_should_explicit"

sweep_root false
brush_assert $? $FIXTURE_NAME "sweep_root_return_when_not_root_and_should_not"
