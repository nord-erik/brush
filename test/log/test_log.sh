#!/bin/bash

FIXTURE_NAME="test_log"
source "$TEST_ROOT/test_base.sh"

# make sure log fns are defined
test_log_function_is_defined() {
  local fn=$1

  sxt_assert_function_defined "$fn"
  sxt_verify $? $FIXTURE_NAME "fn_${fn}_defined"
}

expect_log_to_actually_log() {
  local logger_under_test=$1
  local message=$2
  local expected=$3
  local actual

  actual=$($logger_under_test "$message")
  journalctl --reverse | head -5 | grep --quiet "$message"
  sxt_verify $? $FIXTURE_NAME "${logger_under_test}_can_log_properly"

  test "$actual" = "$expected"
  sxt_verify $? $FIXTURE_NAME "${logger_under_test}_can_produce_proper_log_message"

  # shellcheck disable=SC2181
  if [ $? -ne 0 ]; then
    echo "got:  $actual"
    echo "want: $expected"
  fi

}

# fns exists
test_log_function_is_defined sx_error
test_log_function_is_defined sx_warn
test_log_function_is_defined sx_notice
test_log_function_is_defined sx_log

# fns actually log
TEST_MESSAGE="test_log_error_message_eeaecba723"
TEST_EXPECTED="${SXC_RED}error:$SXC_CLEAR $TEST_MESSAGE"
expect_log_to_actually_log sx_error $TEST_MESSAGE "$TEST_EXPECTED"

TEST_MESSAGE="test_log_warning_message_8fb3a501cb"
TEST_EXPECTED="${SXC_YELLOW}warning:$SXC_CLEAR $TEST_MESSAGE"
expect_log_to_actually_log sx_warn $TEST_MESSAGE "$TEST_EXPECTED"

TEST_MESSAGE="test_log_notice_message_25b55b7d2a"
TEST_EXPECTED="${SXC_BLUE}notice:$SXC_CLEAR $TEST_MESSAGE"
expect_log_to_actually_log sx_notice $TEST_MESSAGE "$TEST_EXPECTED"

TEST_MESSAGE="test_log_info_message_da2bc4d023"
TEST_EXPECTED="${SXC_WHITE}info:$SXC_CLEAR $TEST_MESSAGE"
expect_log_to_actually_log sx_log $TEST_MESSAGE "$TEST_EXPECTED"
