#!/bin/bash

FIXTURE_NAME="logger"
source "$TEST_ROOT/base.sh"
echo "${BRU_CYAN}RUN_TEST${BRU_CLEAR}: $FIXTURE_NAME"

# this is different for diffrent systems
__caputre_log() {
  journalctl -n 5 --reverse --no-pager
}

test_log_can_print() {
  local log_fn=$1
  local log_input=$2
  local expected_output=$3
  local buf_terminal

  buf_terminal=$($log_fn "$log_input")

  # shellcheck disable=SC2181
  if test "$buf_terminal" = "$expected_output"; then
    return 0
  fi

  echo "got:  [$buf_terminal]"
  echo "want: [$expected_output]"

  return 1
}

test_log_can_logger() {
  local log_fn=$1
  local log_input=$2
  local buf_logger expected_keyword expected_log

  case $log_fn in
  bru_error)
    expected_keyword="(ERROR)"
    ;;
  bru_warning)
    expected_keyword="(WARNING)"
    ;;
  bru_notice)
    expected_keyword="(NOTICE)"
    ;;
  bru_log)
    expected_keyword="(INFO)"
    ;;
  *)
    expected_keyword="unknown_logger_under_test"
    ;;
  esac

  # produce the logs and capture it
  $log_fn "$log_input"
  buf_logger="$(__caputre_log)"
  expected_log="$expected_keyword $log_input"

  # shellcheck disable=SC2181
  if echo "$buf_logger" | grep --quiet "$expected_log"; then
    return 0
  fi

  echo "got:  [$buf_logger]"
  echo "want: [$expected_log]"

  return 1
}

# verify api can load
bru_defined bru_error
bru_assert $? $FIXTURE_NAME "bru_error_defined"

bru_defined bru_warning
bru_assert $? $FIXTURE_NAME "bru_warning_defined"

bru_defined bru_notice
bru_assert $? $FIXTURE_NAME "bru_notice_defined"

bru_defined bru_log
bru_assert $? $FIXTURE_NAME "bru_log_defined"

# verify terminal print
test_log_can_print bru_error eeaecba723 "${BRU_RED}error:$BRU_CLEAR eeaecba723"
bru_assert $? $FIXTURE_NAME "bru_error_terminal_output"

test_log_can_print bru_warning 8fb3a501cb "${BRU_YELLOW}warning:$BRU_CLEAR 8fb3a501cb"
bru_assert $? $FIXTURE_NAME "bru_warning_terminal_output"

test_log_can_print bru_notice 25b55b7d2a "${BRU_BLUE}notice:$BRU_CLEAR 25b55b7d2a"
bru_assert $? $FIXTURE_NAME "bru_notice_terminal_output"

test_log_can_print bru_log da2bc4d023 "${BRU_WHITE}info:$BRU_CLEAR da2bc4d023"
bru_assert $? $FIXTURE_NAME "bru_log_terminal_output"

# verify system logs
test_log_can_logger bru_error eeaecba723
bru_assert $? $FIXTURE_NAME "bru_error_logger_output"

test_log_can_logger bru_warning 8fb3a501cb
bru_assert $? $FIXTURE_NAME "bru_warning_logger_output"

test_log_can_logger bru_notice 25b55b7d2a
bru_assert $? $FIXTURE_NAME "bru_notice_logger_output"

test_log_can_logger bru_log da2bc4d023
bru_assert $? $FIXTURE_NAME "bru_log_logger_output"
