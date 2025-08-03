#!/bin/env bash
# shellcheck disable=SC2016

# builds brush and outputs 'bru.sh'

REPO_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
cd "$REPO_ROOT" || exit 112

rm -rf bru.sh
touch bru.sh
chmod 644 bru.sh

# 1) grep all non-comments and non-empty lines, but include shebang
# 2) correct root variables by injecting "src"
grep -v -E "^#[^\!]|^#$|^$" src/brush.sh |
  sed '/BRUSH_ROOT=/a BRUSH_ROOT="$BRUSH_ROOT/src"' > bru.sh
