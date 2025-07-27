#!/bin/bash
# shellcheck disable=SC2034
# shellcheck disable=SC2319

FIXTURE_NAME="sweep_env"
source "$TEST_ROOT/base.sh"
echo "${BRUSH_CYAN}RUN_TEST${BRUSH_CLEAR}: $FIXTURE_NAME"

# verify api can load
brush_defined sweep_env
brush_assert $? $FIXTURE_NAME "sweep_env_defined"

unset BRUSH_TEST_ENV_VAR
(
  sweep_env BRUSH_TEST_ENV_VAR
  return 0
) # capture exit
test $? -eq 1
brush_assert $? $FIXTURE_NAME "sweep_env_when_not_defined"

BRUSH_TEST_ENV_VAR="isset"
sweep_env BRUSH_TEST_ENV_VAR
brush_assert $? $FIXTURE_NAME "sweep_env_when_defined"

BRUSH_TEST_ENV_VAR=""
sweep_env BRUSH_TEST_ENV_VAR
brush_assert $? $FIXTURE_NAME "sweep_env_when_defined_as_zero_should_not_boom"

return 0
