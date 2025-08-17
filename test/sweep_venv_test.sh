#!/bin/env bash
# shellcheck disable=SC2034

FIXTURE_NAME="sweep_venv"
brush_test_fixture "$FIXTURE_NAME"

# verify api can load
brush_defined sweep_is_venv
brush_assert $? $FIXTURE_NAME "sweep_is_venv_defined"

unset VIRTUAL_ENV
(
    sweep_is_venv
    return 0
) # capture exit
test $? -eq 1
brush_assert $? $FIXTURE_NAME "sweep_is_venv_when_not_in"

VIRTUAL_ENV="isset"
sweep_is_venv
brush_assert $? $FIXTURE_NAME "sweep_is_venv_when_defined"

VIRTUAL_ENV=""
(
    sweep_is_venv
    return 0
) # capture exit
test $? -eq 1
brush_assert $? $FIXTURE_NAME "sweep_is_venv_when_defined_as_zero_should_also_boom"

return 0
