#!/bin/bash

FIXTURE_NAME="sweep_git"
printf "%s\n" "${BRUSH_CYAN}RUN_TEST${BRUSH_CLEAR}: $FIXTURE_NAME"

# verify api can load
brush_defined sweep_git_is_clean
brush_assert $? $FIXTURE_NAME "sweep_git_is_clean"

brush_defined sweep_git_is_init
brush_assert $? $FIXTURE_NAME "sweep_git_is_init"

brush_defined sweep_git_is_on
brush_assert $? $FIXTURE_NAME "sweep_git_is_on"

return 0
