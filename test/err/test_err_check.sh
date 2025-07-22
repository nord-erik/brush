#!/bin/bash

FIXTURE_NAME="test_err_check"
source "$TEST_ROOT/test_base.sh"

mock_process_0() {
  return 0
}

mock_process_1() {
  return 1
}

mock_process_rand() {
  return "$(shuf -i 2-1000 -n 1)"
}

expect_0_to_be_ok() {
  mock_process_0
  # shellcheck disable=SC2091
  $(sx_check $?)
  sxt_verify $? $FIXTURE_NAME "check_works_on_0"
}

expect_1_to_be_nok() {
  # capture the exit, set to 0 if exit happened
  did_exit=1
  mock_process_1
  # shellcheck disable=SC2091
  $(sx_check $?) || did_exit=0
  sxt_verify $did_exit $FIXTURE_NAME "check_works_on_1"
}

expect_random_to_be_nok() {
  # capture the exit, set to 0 if exit happened
  did_exit=1
  mock_process_rand
  random_value_was=$?
  # shellcheck disable=SC2091
  $(sx_check $random_value_was) || did_exit=0
  sxt_verify $did_exit $FIXTURE_NAME "check_works_on_rand_($random_value_was)"
}

expect_no_message_to_print_nothing() {
  buf_err=$( (sx_check 1) 2>&1)
  test -z "$buf_err"
  sxt_verify $? $FIXTURE_NAME "no_message_when_no_message"
}

expect_message_to_print() {
  buf_err=$( (sx_check 1 "error") 2>&1)
  test -n "$buf_err"
  sxt_verify $? $FIXTURE_NAME "a_message_when_message"
}

expect_message_to_be_stderr() {
  buf_out=$( (sx_check 1 "error"))
  buf_err=$( (sx_check 1 "error") 2>&1)
  test -z "$buf_out" && test -n "$buf_err"
  sxt_verify $? $FIXTURE_NAME "messages_sent_to_stderr"
}

expect_message_to_be_equal() {
  message="it should be possible to pass a proper string"
  buf_err=$( (sx_check 1 "$message") 2>&1)
  test "$message" = "$buf_err"
  sxt_verify $? $FIXTURE_NAME "messages_are_equal_to_sent_argumetn"
}

# run the tests
# error codes
expect_0_to_be_ok
expect_1_to_be_nok
expect_random_to_be_nok

# messages
expect_no_message_to_print_nothing
expect_message_to_print
expect_message_to_be_stderr
expect_message_to_be_equal
