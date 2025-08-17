#!/bin/env bash

# this script serves as a sort fo import all sweeps / import the whole lib
# source this file and all sweeps gets loaded
# you can optinally pass one and only one argument to the source
# the passed argument will be the name for the script in log fil
# when build script runs, this is the main entry point for the build
# the script as a whole gets minified and all sources gets in-place replaced by the target scripts contents

BRUSH_APP_NAME=$1
if [ -z "$BRUSH_APP_NAME" ]; then
    BRUSH_APP_NAME="bru.sh"
fi
export BRUSH_APP_NAME

BRUSH_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
SWEEPS_ROOT="$BRUSH_ROOT/sweeps"

# make sure we load the constants first
source "$BRUSH_ROOT/consts.sh"

# then we load the logging utilities
source "$BRUSH_ROOT/logger.sh"

# sweeps (order might matter -- have not tested different order):
source "$SWEEPS_ROOT/command.sh"
source "$SWEEPS_ROOT/env.sh"
source "$SWEEPS_ROOT/nok.sh"
source "$SWEEPS_ROOT/ok.sh"
source "$SWEEPS_ROOT/sudo.sh"
source "$SWEEPS_ROOT/venv.sh"

# git add on
source "$SWEEPS_ROOT/git/is_clean.sh"
source "$SWEEPS_ROOT/git/is_init.sh"
source "$SWEEPS_ROOT/git/is_on.sh"

unset BRUSH_ROOT
unset SWEEPS_ROOT
