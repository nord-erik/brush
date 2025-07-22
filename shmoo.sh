#!/bin/bash

SX_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
SX_ROOT="$SX_ROOT/sx"
export SX_ROOT

source "$SX_ROOT/err/check.sh"
source "$SX_ROOT/err/try.sh"
