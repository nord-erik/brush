#!/bin/bash

FIXTURE_NAME="logger"
printf "%s\n" "${BRUSH_CYAN}RUN_TEST${BRUSH_CLEAR}: $FIXTURE_NAME"

# this is different for diffrent systems
_caputre_log() {
  journalctl -n 15 --reverse --no-pager
}

test_log_can_print() {
  local log_fn=$1
  local log_input=$2
  local expected_output=$3
  local should_stderr=$4
  local buf_terminal

  if [ "$should_stderr" = "true" ]; then
    buf_terminal=$($log_fn "$log_input" 2>&1 > /dev/null)
  else
    buf_terminal=$($log_fn "$log_input")
  fi

  # shellcheck disable=SC2181
  if test "$buf_terminal" = "$expected_output"; then
    return 0
  fi

  printf "%s\n" "got:  [$buf_terminal]"
  printf "%s\n" "want: [$expected_output]"

  return 1
}

test_log_can_logger() {
  local log_fn=$1
  local log_input=$2
  local buf_logger expected_keyword expected_log

  case $log_fn in
  brush_error)
    expected_keyword="(ERROR)"
    ;;
  brush_warning)
    expected_keyword="(WARNING)"
    ;;
  brush_notice)
    expected_keyword="(NOTICE)"
    ;;
  brush_log)
    expected_keyword="(INFO)"
    ;;
  *)
    expected_keyword="unknown_logger_under_test"
    ;;
  esac

  # produce the logs and capture it
  $log_fn "$log_input" > /dev/null
  buf_logger="$(_caputre_log)"
  expected_log="$expected_keyword $log_input"

  # shellcheck disable=SC2181
  if printf "%s\n" "$buf_logger" | grep --quiet "$expected_log"; then
    return 0
  fi

  printf "%s\n" "got:  [$buf_logger]"
  printf "%s\n" "want: [$expected_log]"

  return 1
}

# verify api can load
brush_defined brush_error
brush_assert $? $FIXTURE_NAME "brush_error_defined"

brush_defined brush_warning
brush_assert $? $FIXTURE_NAME "brush_warning_defined"

brush_defined brush_notice
brush_assert $? $FIXTURE_NAME "brush_notice_defined"

brush_defined brush_log
brush_assert $? $FIXTURE_NAME "brush_log_defined"

# verify terminal print
test_log_can_print brush_error test_eeaecba723 "${BRUSH_RED}error:$BRUSH_CLEAR test_eeaecba723" true
brush_assert $? $FIXTURE_NAME "brush_error_stderr_terminal_output"

test_log_can_print brush_warning test_8fb3a501cb "${BRUSH_YELLOW}warning:$BRUSH_CLEAR test_8fb3a501cb" false
brush_assert $? $FIXTURE_NAME "brush_warning_terminal_output"

test_log_can_print brush_notice test_25b55b7d2a "${BRUSH_BLUE}notice:$BRUSH_CLEAR test_25b55b7d2a" false
brush_assert $? $FIXTURE_NAME "brush_notice_terminal_output"

test_log_can_print brush_log test_da2bc4d023 "${BRUSH_WHITE}info:$BRUSH_CLEAR test_da2bc4d023" false
brush_assert $? $FIXTURE_NAME "brush_log_terminal_output"

# verify system logs
test_log_can_logger brush_error test_eeaecba723
brush_assert $? $FIXTURE_NAME "brush_error_logger_output"

test_log_can_logger brush_warning test_8fb3a501cb
brush_assert $? $FIXTURE_NAME "brush_warning_logger_output"

test_log_can_logger brush_notice test_25b55b7d2a
brush_assert $? $FIXTURE_NAME "brush_notice_logger_output"

test_log_can_logger brush_log test_da2bc4d023
brush_assert $? $FIXTURE_NAME "brush_log_logger_output"
