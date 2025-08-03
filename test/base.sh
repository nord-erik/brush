#!/bin/env bash

# this file contains utilities and variables and etc that is useful for all testing
# all test scripts should soruce this to gain the common utilities
# sort of like a base test class for all other tests
# also makes sure that the test fixture has brush loaded in the process

# if any other script already sourced this, then skip doing it again
if [ "$_BRUSH_IS_SOURCED" = "true" ]; then
  return 0
fi

TEST_APP_NAME="bru.sh(test)"
source "$TEST_ROOT/../bru.sh" "$TEST_APP_NAME"
BRUSH_TEST_PRINTS_PASSES=$1

# report that a test has failed
_brush_report_fail() {
  local test_file_name=$1 test_name=$2

  printf "\t%b%s%b\t%s\n" "$BRUSH_RED" "FAIL" "$BRUSH_CLEAR" "$test_file_name # $test_name"
}

# report that a test has passed
_brush_report_pass() {
  local test_file_name=$1 test_name=$2

  printf "\t%b%s%b\t%s\n" "$BRUSH_GREEN" "OK" "$BRUSH_CLEAR" "$test_file_name / $test_name"
}

brush_test_fixture() {
  local fixture_name=$1

  printf "%b%s%b%s\n" "$BRUSH_CYAN" "RUN_TEST" "$BRUSH_CLEAR" ": $fixture_name"
}

# assert code is 0 => test pass, if other => test fail
brush_assert() {
  local code=$1 test_file_name=$2 test_name=$3

  # shellcheck disable=SC2086
  if [ $code -ne 0 ]; then
    _brush_report_fail "$test_file_name" "$test_name"
  else
    if [ "$BRUSH_TEST_PRINTS_PASSES" = "true" ]; then
      _brush_report_pass "$test_file_name" "$test_name"
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
  local test_file_name=$1 test_name=$2

  printf "\t%b%s%b\t%s\n" "$BRUSH_YELLOW" "SKIP" "$BRUSH_CLEAR" "$test_file_name / $test_name"
}

brush_test_fixture "base"
test "$BRUSH_APP_NAME" = "$TEST_APP_NAME"
brush_assert $? "test_base" "verify_app_name"

_BRUSH_IS_SOURCED=true
export _BRUSH_IS_SOURCED
