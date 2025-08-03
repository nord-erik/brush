#!/bin/bash

# this script serves as a sort fo import all sweeps / import the whole lib
# source this file and all sweeps gets loaded
#
# you can pass optinally one and only one argument to the source
# the passed argument will be the name for the script in log file

BRUSH_APP_NAME=$1
BRUSH_DEFAULT_APP_NAME="bru.sh"

if [ -z "$BRUSH_APP_NAME" ]; then
  BRUSH_APP_NAME="$BRUSH_DEFAULT_APP_NAME"
fi

export BRUSH_APP_NAME
# visible for testing
export BRUSH_DEFAULT_APP_NAME

BRUSH_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
SWEEPS_ROOT="$BRUSH_ROOT/src/sweeps"

# make sure we load the constants first
source "$BRUSH_ROOT/src/consts.sh"

# then we load the logging utilities
source "$BRUSH_ROOT/src/logger.sh"

# sweeps (order might matter -- have not tested different order):
source "$SWEEPS_ROOT/command.sh"
source "$SWEEPS_ROOT/env.sh"
source "$SWEEPS_ROOT/nok.sh"
source "$SWEEPS_ROOT/ok.sh"
source "$SWEEPS_ROOT/sudo.sh"

# git add on
source "$SWEEPS_ROOT/git/is_clean.sh"
source "$SWEEPS_ROOT/git/is_init.sh"
source "$SWEEPS_ROOT/git/is_on.sh"

unset BRUSH_ROOT
unset SWEEPS_ROOT
