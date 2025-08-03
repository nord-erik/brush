#!/bin/env bash
BRUSH_APP_NAME=$1
BRUSH_DEFAULT_APP_NAME="bru.sh"
if [ -z "$BRUSH_APP_NAME" ]; then
  BRUSH_APP_NAME="$BRUSH_DEFAULT_APP_NAME"
fi
export BRUSH_APP_NAME
export BRUSH_DEFAULT_APP_NAME
BRUSH_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
BRUSH_ROOT="$BRUSH_ROOT/src"
SWEEPS_ROOT="$BRUSH_ROOT/sweeps"
source "$BRUSH_ROOT/consts.sh"
source "$BRUSH_ROOT/logger.sh"
source "$SWEEPS_ROOT/command.sh"
source "$SWEEPS_ROOT/env.sh"
source "$SWEEPS_ROOT/nok.sh"
source "$SWEEPS_ROOT/ok.sh"
source "$SWEEPS_ROOT/sudo.sh"
source "$SWEEPS_ROOT/git/is_clean.sh"
source "$SWEEPS_ROOT/git/is_init.sh"
source "$SWEEPS_ROOT/git/is_on.sh"
unset BRUSH_ROOT
unset SWEEPS_ROOT
