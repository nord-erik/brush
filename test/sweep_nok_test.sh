#!/bin/env bash

FIXTURE_NAME="sweep_nok"
brush_test_fixture "$FIXTURE_NAME"

# verify api can load
brush_defined sweep_nok
brush_assert $? $FIXTURE_NAME "sweep_nok_defined"

# error codes
sweep_nok 1
test $? -eq 0
brush_assert $? $FIXTURE_NAME "sweep_nok_returns_on_1"

(
  sweep_nok 0
  return 0
) # capture the exit
test $? -eq 1
brush_assert $? $FIXTURE_NAME "sweep_nok_exits_on_0"

(
  sweep_nok 0 "" 10
  return 0
) # capture the exit
test $? -eq 10
brush_assert $? $FIXTURE_NAME "sweep_nok_exits_on_custom_error_code"

# message propagation
expect_no_message_to_print_nothing() {
  local buf_err

  buf_err=$( (sweep_nok 0) 2>&1)
  test -z "$buf_err"
}

expect_message_to_print() {
  local buf_err

  buf_err=$( (sweep_nok 0 "testing error prints") 2>&1 > /dev/null)
  test -n "$buf_err"
}

expect_message_to_be_stderr() {
  local buf_out buf_err

  buf_out=$( (sweep_nok 0 "deliberate testing error") 2> /dev/null)
  buf_err=$( (sweep_nok 0 "deliberate testing error") 2>&1 > /dev/null)
  test -z "$buf_out" && test -n "$buf_err"
}

expect_message_to_be_equal() {
  local msg expected buf_err

  msg="testing possibility to pass a proper string"
  expected="${BRUSH_RED}error:${BRUSH_CLEAR} $msg"
  buf_err=$( (sweep_nok 0 "$msg") 2>&1 > /dev/null)
  test "$expected" = "$buf_err"
}

expect_no_message_to_print_nothing
brush_assert $? $FIXTURE_NAME "sweep_nok_no_message_when_no_message"

expect_message_to_print
brush_assert $? $FIXTURE_NAME "sweep_nok_a_message_when_message"

expect_message_to_be_stderr
brush_assert $? $FIXTURE_NAME "sweep_nok_messages_sent_to_stderr"

expect_message_to_be_equal
brush_assert $? $FIXTURE_NAME "sweep_nok_error_messages_contains_input"

return 0
