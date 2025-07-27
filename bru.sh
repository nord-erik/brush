#!/bin/bash

# this script serves as a sort fo import all sweeps / import the whole lib
# source this file and all sweeps gets loaded
#
# you can pass optinally one and only one argument to the source
# the passed argument will be the name for the script in log file

BRU_APP_NAME=$1

if [ -z "$BRU_APP_NAME" ]; then
  BRU_APP_NAME="bru.sh"
fi

export BRU_APP_NAME

BRUSH_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
export BRUSH_ROOT

SWEEP_ROOT="$BRUSH_ROOT/sweep"
export SWEEP_ROOT

# make sure we load the constants
source "$BRUSH_ROOT/consts.sh"

# load the logging utilities
source "$BRUSH_ROOT/logger.sh"

# sweeps:
source "$SWEEP_ROOT/command.sh"
source "$SWEEP_ROOT/ok.sh"
