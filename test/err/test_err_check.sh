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
  sxt_verify $did_exit $FIXTURE_NAME "check_works_on_rand ($random_value_was)"
}

# run the tests
expect_0_to_be_ok
expect_1_to_be_nok
expect_random_to_be_nok
