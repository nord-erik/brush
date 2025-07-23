#!/bin/bash

# SET $1 = "SILENCE" to silence successful runs
# applies shfmt on all files, then runs shellcheck on all files, then runs tests -- error codes:
#   0 => all ok
#   1 => dependencies not available
#   2 => shellcheck nags
#   3 => shfmt nags
#   4 => tests fail

HOOK_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
cd "$HOOK_ROOT" || exit 112

if ! command -v shellcheck > /dev/null 2>&1; then
  echo ""
  echo "command 'shellcheck' missing please install it"
  exit 1
fi

if ! command -v shfmt > /dev/null 2>&1; then
  echo ""
  echo "command 'shfmt' missing please install it"
  exit 1
fi

if ! find . -type f -name "*.sh" -exec shellcheck -- {} +; then
  echo ""
  echo "error - check formatter issues"
  exit 2
fi

if shfmt --space-redirects --diff --indent 2 . >/dev/null; then
  echo ""
  echo "error - check formatter issues"
  exit 3
fi

test_log="$("$HOOK_ROOT"/test/run_all_tests.sh)"

# $? == 0 means we found the pattern of "FAIL", i.e. we have failures
if echo "$test_log" | grep -q "FAIL"; then
  echo "$test_log"
  echo ""
  echo "error - tests are not passing"
  exit 4
fi

if [ "$1" != "SILENT" ]; then
  echo "HOOK SUCCESS WITH EXIT CODE: 0"
fi
