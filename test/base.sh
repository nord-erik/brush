#!/bin/bash

# this file contains utilities and variables and etc that is useful for all testing
# all test scripts should soruce this to gain the common utilities
# sort of like a base test class for all other tests

# if any other script already sourced this, then skip doing it again
if [ "$SXT_IS_BASE_SOURCED" = "true" ]; then
  return 0
else
  # constants not yet sourced....
  printf "%b%s%b%s\n" $'\033[36m' "RUN_TEST" $'\033[0m' ": base"
fi

VERBOSE=1
NAME="bru.sh(test)"

source "$TEST_ROOT/../bru.sh" "$NAME"

# report that a test has failed
__brush_report_fail() {
  local test_file_name=$1
  local test_name=$2

  printf "\t%b%s%b\t%s\n" "$BRUSH_RED" "FAIL" "$BRUSH_CLEAR" "$test_file_name # $test_name"
}

# report that a test has passed
__brush_report_pass() {
  local test_file_name=$1
  local test_name=$2

  printf "\t%b%s%b\t%s\n" "$BRUSH_GREEN" "OK" "$BRUSH_CLEAR" "$test_file_name / $test_name"
}

# assert code is 0 => test pass, if other => test fail
brush_assert() {
  local code=$1
  local test_file_name=$2
  local test_name=$3

  # shellcheck disable=SC2086
  if [ $code -ne 0 ]; then
    __brush_report_fail "$test_file_name" "$test_name"
  else
    if [ $VERBOSE -eq 1 ]; then
      __brush_report_pass "$test_file_name" "$test_name"
    fi
  fi

  return "$code"
}

brush_defined() {
  local fn=$1

  if [ "$(type -t "$fn")" = "function" ]; then
    return 0
  fi

  return 1
}

brush_skip() {
  local test_file_name=$1
  local test_name=$2

  printf "\t%b%s%b\t%s\n" "$BRUSH_YELLOW" "SKIP" "$BRUSH_CLEAR" "$test_file_name / $test_name"
}

# verify that app name is propagated when you initiate
test "$BRUSH_APP_NAME" = "$NAME"
brush_assert $? "test_base" "verify_app_name"

SXT_IS_BASE_SOURCED=true
export SXT_IS_BASE_SOURCED
