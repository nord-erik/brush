#!/bin/bash
# shellcheck disable=SC2319

FIXTURE_NAME="sweep_ok"
source "$TEST_ROOT/base.sh"
echo "${BRU_CYAN}RUN_TEST${BRU_CLEAR}: $FIXTURE_NAME"

# verify api can load
bru_defined sweep_ok
bru_assert $? $FIXTURE_NAME "sweep_ok_defined"

# error codes
sweep_ok 0
test $? -eq 0
bru_assert $? $FIXTURE_NAME "sweep_ok_on_0"

(
  sweep_ok 1
  return 0
) # capture the exit
test $? -eq 1
bru_assert $? $FIXTURE_NAME "check_works_on_1"

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
  expected="${BRU_RED}error:${BRU_CLEAR} $msg"
  buf_err=$( (sweep_ok 1 "$msg") 2>&1 > /dev/null)
  test "$expected" = "$buf_err"
}

expect_no_message_to_print_nothing
bru_assert $? $FIXTURE_NAME "no_message_when_no_message"

expect_message_to_print
bru_assert $? $FIXTURE_NAME "a_message_when_message"

expect_message_to_be_stderr
bru_assert $? $FIXTURE_NAME "messages_sent_to_stderr"

expect_message_to_be_equal
bru_assert $? $FIXTURE_NAME "messages_are_equal_to_sent_argumet"
