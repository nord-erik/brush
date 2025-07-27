#!/bin/bash

# set $1 = "VERBOSE" to be less funky...
# this polishing script will check the code for lint errors and formatting errors, then run all tests
# error codes signifiy outcomes:
#   0 => all ok
#   1 => dependencies not available
#   2 => shellcheck nags
#   3 => shfmt nags
#   4 => tests fail
# 112 => your file system does not work

HOOK_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
cd "$HOOK_ROOT" || exit 112
source "$HOOK_ROOT"/bru.sh

sweep_command shellcheck && sweep_command shfmt

static_checks() {
  # run formatter over all sh files
  find . -type f -name "*.sh" -exec shellcheck -- {} +
  sweep_ok $? "check lint issues" 2

  shfmt --space-redirects --diff --indent 2 .
  sweep_ok $? "check formatter issues, or quickly apply with:
        shfmt --space-redirects --write --indent 2 ." 3
}

testing_run_all() {
  printf "%s\n" "$("$HOOK_ROOT"/test/all.sh)"
}

testing_checks() {
  local test_report=$1

  printf "%s" "$test_report" | grep -q "FAIL"
  test $? -eq 1
  sweep_ok $? "tests are not passing" 4

  printf "%s" "$test_report" | grep -q "CRASHED"
  test $? -eq 1
  sweep_ok $? "tests are crashing" 4
}

polish() {
  local verbose=$1
  local test_report

  static_checks
  test_report=$(testing_run_all)

  if [ "$verbose" == "VERBOSE" ]; then
    printf "%s\n" "$test_report"
  fi

  testing_checks "$test_report"

  if [ "$verbose" == "VERBOSE" ]; then
    printf "POLISH SUCCESS WITH EXIT CODE: 0\n"
  else
    printf "%b%s%b\n" "$BRUSH_LIGHT_GREEN" "polish complete" "$BRUSH_CLEAR"
  fi
}

polish "$1"
