#!/bin/env bash

SCRIPT_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
cd "$SCRIPT_ROOT" || exit 112
source "$SCRIPT_ROOT"/src/brush.sh
