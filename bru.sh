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
export BRUSH_DEFAULT_APP_NAME

BRUSH_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
export BRUSH_ROOT

SWEEP_ROOT="$BRUSH_ROOT/sweep"
export SWEEP_ROOT

# make sure we load the constants first
source "$BRUSH_ROOT/consts.sh"

# then we load the logging utilities
source "$BRUSH_ROOT/logger.sh"

# sweeps (order might matter -- have not tested different order):
source "$SWEEP_ROOT/command.sh"
source "$SWEEP_ROOT/nok.sh"
source "$SWEEP_ROOT/ok.sh"
source "$SWEEP_ROOT/sudo.sh"
