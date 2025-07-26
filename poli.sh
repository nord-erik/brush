#!/bin/bash

# set $1 = "VERBOSE" to be less funky...
#
# applies shfmt on all files, then runs shellcheck on all files, then runs tests -- error codes:
#   0 => all ok
#   1 => dependencies not available
#   2 => shellcheck nags
#   3 => shfmt nags
#   4 => tests fail
# 112 => your file system does not work

HOOK_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
cd "$HOOK_ROOT" || exit 112

if ! command -v shellcheck > /dev/null 2>&1; then
  echo ""
  echo "error - command 'shellcheck' missing please install it"
  exit 1
fi

if ! command -v shfmt > /dev/null 2>&1; then
  echo ""
  echo "error - command 'shfmt' missing please install it"
  exit 1
fi

if ! find . -type f -name "*.sh" -exec shellcheck -- {} +; then
  echo ""
  echo "error - check formatter issues"
  exit 2
fi

shfmt --space-redirects --diff --indent 2 .

if test $? -ne 0; then
  echo ""
  echo "error - check formatter issues"
  echo "        if you agree with all, quickly apply with"
  echo "        shfmt --space-redirects --write --indent 2 ."
  exit 3
fi

test_log="$("$HOOK_ROOT"/test/all.sh)"

# $? == 0 means we found the pattern of "FAIL", i.e. we have failures
if echo "$test_log" | grep -q "FAIL"; then
  echo "$test_log"
  echo ""
  echo "error - tests are not passing"
  exit 4
fi

if [ "$1" == "VERBOSE" ]; then
  echo "POLISH SUCCESS WITH EXIT CODE: 0"
else
  echo -e "\033[92mpolish complete\033[0m"
fi
