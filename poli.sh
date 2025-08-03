#!/bin/env bash

# error codes signifiy outcomes:
#   0 => all ok
#   1 => dependencies not available
#   2 => shellcheck nags
#   3 => shfmt nags
#   4 => tests fail
# 112 => your file system does not work

# load brush library
POLISH_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
cd "$POLISH_ROOT" || exit 112

if [ ! -f "$POLISH_ROOT/bru.sh" ]; then
  printf "%s\n" "where is bru? build bru please"
  exit 1
fi

source "$POLISH_ROOT/bru.sh"

# check this script's dependencies
sweep_command shellcheck shfmt git

_run_linter_on_all_files() {
  find . -type f ! -name "bru.sh" -name "*.sh" -exec shellcheck -- {} +
  return $?
}

_run_formatter_on_all_files() {
  shfmt --space-redirects --diff --indent 2 src test build.sh poli.sh
  return $?
}

_static_checks() {
  _run_linter_on_all_files
  sweep_ok $? "check linting issues" 2

  _run_formatter_on_all_files
  sweep_ok $? "check formatter issues, or quickly apply with:
        shfmt --space-redirects --write --indent 2 ." 3
}

_run_all_tests() {
  printf "%s\n" "$("$POLISH_ROOT"/test/all.sh)"
  return $?
}

_illustrate_test_report() {
  local test_report=$1
  local number_executed number_found

  printf "%s" "$test_report" | grep --quiet "FAIL"
  sweep_nok $? "tests are not passing" 4

  printf "%s" "$test_report" | grep --quiet "CRASHED"
  sweep_nok $? "tests are crashing" 4

  # the space after brush_assert is imporant to not include brush_assert's declaration
  number_found=$(grep --dereference-recursive --include="*.sh" "brush_assert " "$POLISH_ROOT"/test | wc --lines)
  number_executed=$(printf "%s" "$test_report" | grep --extended-regexp "(OK|SKIP)" | wc --lines)

  test "$number_found" = "$number_executed"
  sweep_ok $? "not all tests executed, found [$number_found] test cases, but [$number_executed] was present in test report"
}

_polish() {
  local verbose=$1
  local test_report

  _static_checks
  test_report=$(_run_all_tests)

  if [ "$verbose" == "VERBOSE" ]; then
    printf "%s\n" "$test_report"
  fi

  _illustrate_test_report "$test_report"

  printf "%b%s%b\n" "$BRUSH_LIGHT_GREEN" "polish complete" "$BRUSH_CLEAR"
}

_polish "$1"
