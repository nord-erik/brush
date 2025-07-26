#!/bin/bash

# this script serves as a sort fo import all sweeps / import the whole lib
# source this file and all sweeps gets loaded
#
# you can pass optinally one and only one argument to the source
# the passed argument will be the name for the script in log file

SX_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
SX_ROOT="$SX_ROOT/sx"
export SX_ROOT

SX_APP_NAME=$1

if [ -z "$SX_APP_NAME" ]; then
  SX_APP_NAME="bru.sh"
fi

export SX_APP_NAME

# global variable
source "$SX_ROOT/consts.sh"

# logging components
source "$SX_ROOT/log/logger.sh"

# error checking components
source "$SX_ROOT/err/check.sh"

# guards
source "$SX_ROOT/guard/is_command.sh"
source "$SX_ROOT/guard/is_file.sh"
