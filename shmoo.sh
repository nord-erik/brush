#!/bin/bash

SX_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
SX_ROOT="$SX_ROOT/sx"
export SX_ROOT

SX_APP_NAME=$1

if [ -z "$SX_APP_NAME" ]; then
  SX_APP_NAME="shmooth-app"
fi

export SX_APP_NAME

# logging components
source "$SX_ROOT/log/error.sh"
source "$SX_ROOT/log/info.sh"
source "$SX_ROOT/log/log.sh"
source "$SX_ROOT/log/warn.sh"

# error checking components
source "$SX_ROOT/err/check.sh"

# guards
source "$SX_ROOT/guard/is_command.sh"
source "$SX_ROOT/guard/is_file.sh"
