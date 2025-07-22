#!/bin/bash

SX_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
SX_ROOT="$SX_ROOT/sx"
export SX_ROOT

# logging components
source "$SX_ROOT/log/error.sh"
source "$SX_ROOT/log/info.sh"
source "$SX_ROOT/log/log.sh"
source "$SX_ROOT/log/warn.sh"

# error checking components
source "$SX_ROOT/err/check.sh"
source "$SX_ROOT/err/try.sh"
