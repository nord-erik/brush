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
  local actual_terminal actual_log keyword

  case $logger_under_test in
  sx_error)
    keyword="(ERROR)"
    ;;
  sx_warn)
    keyword="(WARNING)"
    ;;
  sx_notice)
    keyword="(NOTICE)"
    ;;
  sx_log)
    keyword="(INFO)"
    ;;
  *)
    keyword="unknown_logger_under_test"
    ;;
  esac

  actual_terminal=$($logger_under_test "$message")
  actual_log="$(journalctl --reverse | head -1)"
  echo "$actual_log" | grep --quiet "$keyword $message"
  sxt_verify $? $FIXTURE_NAME "${logger_under_test}_can_log_properly"

  # shellcheck disable=SC2181
  if [ $? -ne 0 ]; then
    echo "got:  [$actual_log]"
    echo "want: [$keyword $message]"
  fi

  test "$actual_terminal" = "$expected"
  sxt_verify $? $FIXTURE_NAME "${logger_under_test}_can_produce_proper_terminal_message"

  # shellcheck disable=SC2181
  if [ $? -ne 0 ]; then
    echo "got:  [$actual_terminal]"
    echo "want: [$expected]"
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
