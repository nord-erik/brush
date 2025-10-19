#!/bin/env bash

# this script serves as a sort of import all sweeps / import the whole lib
# source this file and all sweeps gets loaded
# you can optionally pass one and only one argument to the source
# the passed argument will be the name for the script in log file
# when build script runs, this is the main entry point for the build
# the script as a whole gets minified and all sources gets in-place replaced by the target scripts contents

BRUSH_APP_NAME=$1
if [ -z "$BRUSH_APP_NAME" ]; then
    BRUSH_APP_NAME="bru.sh"
fi
export BRUSH_APP_NAME

SWEEPS_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)/sweeps

# make sure we load the constants and logger utility first
source "$SWEEPS_ROOT/consts.sh"
source "$SWEEPS_ROOT/logger.sh"

# sweeps (order might matter -- have not tested different order):
## common
source "$SWEEPS_ROOT/common/command.sh"
source "$SWEEPS_ROOT/common/env.sh"
source "$SWEEPS_ROOT/common/nok.sh"
source "$SWEEPS_ROOT/common/ok.sh"
source "$SWEEPS_ROOT/common/sudo.sh"

## git add on
source "$SWEEPS_ROOT/git/is_clean.sh"
source "$SWEEPS_ROOT/git/is_init.sh"
source "$SWEEPS_ROOT/git/is_on.sh"

## python add on
source "$SWEEPS_ROOT/python/venv.sh"

unset SWEEPS_ROOT
