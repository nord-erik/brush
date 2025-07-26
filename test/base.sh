#!/bin/bash

# this file contains utilities and variables and etc that is useful for all testing
# all test scripts should soruce this to gain the common utilities
# sort of like a base test class for all other tests

# if any other script already sourced this, then skip doing it again
if [ "$SXT_IS_BASE_SOURCED" = "true" ]; then
  return 0
fi

VERBOSE=1
NAME="bru.sh(test)"

source "$TEST_ROOT/../bru.sh" "$NAME"

# report that a test has failed
__sxt_report_test_fail() {
  local test_file_name=$1
  local test_name=$2

  echo -e "${SXC_RED}FAIL    ::::${SXC_CLEAR}    $test_file_name # $test_name"
}

# report that a test has passed
__sxt_report_test_ok() {
  local test_file_name=$1
  local test_name=$2

  echo -e "${SXC_GREEN}OK${SXC_CLEAR} $test_file_name / $test_name"
}

# assert code is 0 => test pass, if other => test fail
sxt_verify() {
  local code=$1
  local test_file_name=$2
  local test_name=$3

  # shellcheck disable=SC2086
  if [ $code -ne 0 ]; then
    __sxt_report_test_fail "$test_file_name" "$test_name"
  else
    if [ $VERBOSE -eq 1 ]; then
      __sxt_report_test_ok "$test_file_name" "$test_name"
    fi
  fi

  return "$code"
}

sxt_assert_function_defined() {
  local fn=$1

  if [ "$(type -t "$fn")" = "function" ]; then
    return 0
  fi

  return 1
}

# verify that app name is propagated when you initiate
test "$SX_APP_NAME" = "$NAME"
sxt_verify $? "test_base" "verify_app_name"

SXT_IS_BASE_SOURCED=true
export SXT_IS_BASE_SOURCED
