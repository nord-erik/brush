#!/bin/bash
# shellcheck disable=SC2319

FIXTURE_NAME="sweep_ok"
source "$TEST_ROOT/base.sh"
echo "${BRUSH_CYAN}RUN_TEST${BRUSH_CLEAR}: $FIXTURE_NAME"

# verify api can load
brush_defined sweep_ok
brush_assert $? $FIXTURE_NAME "sweep_ok_defined"

# error codes
sweep_ok 0
test $? -eq 0
brush_assert $? $FIXTURE_NAME "sweep_ok_on_0"

(
  sweep_ok 1
  return 0
) # capture the exit
test $? -eq 1
brush_assert $? $FIXTURE_NAME "check_works_on_1"

(
  sweep_ok 1 "" 10
  return 0
) # capture the exit
test $? -eq 10
brush_assert $? $FIXTURE_NAME "check_custom_error_code_works"

# message propagation
expect_no_message_to_print_nothing() {
  local buf_err

  buf_err=$( (sweep_ok 1) 2>&1)
  test -z "$buf_err"
}

expect_message_to_print() {
  local buf_err

  buf_err=$( (sweep_ok 1 "deliberate testing error") 2>&1 > /dev/null)
  test -n "$buf_err"
}

expect_message_to_be_stderr() {
  local buf_out
  local buf_err

  buf_out=$( (sweep_ok 1 "deliberate testing error") 2> /dev/null)
  buf_err=$( (sweep_ok 1 "deliberate testing error") 2>&1 > /dev/null)
  test -z "$buf_out" && test -n "$buf_err"
}

expect_message_to_be_equal() {
  local msg expected buf_err

  msg="it should be possible to pass a proper string"
  expected="${BRUSH_RED}error:${BRUSH_CLEAR} $msg"
  buf_err=$( (sweep_ok 1 "$msg") 2>&1 > /dev/null)
  test "$expected" = "$buf_err"
}

expect_no_message_to_print_nothing
brush_assert $? $FIXTURE_NAME "no_message_when_no_message"

expect_message_to_print
brush_assert $? $FIXTURE_NAME "a_message_when_message"

expect_message_to_be_stderr
brush_assert $? $FIXTURE_NAME "messages_sent_to_stderr"

expect_message_to_be_equal
brush_assert $? $FIXTURE_NAME "messages_are_equal_to_sent_argumet"
