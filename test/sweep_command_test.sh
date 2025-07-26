#!/bin/bash

FIXTURE_NAME="test_guard_is_command"
source "$TEST_ROOT/base.sh"

test_command_exist() {
  sx_is_command cat
}

test_command_not_exist() {
  (
    sx_is_command command_does_not_exits 2> /dev/null
    return 0
  ) # capture the exit
  test $? -eq 1
  return $?
}

sxt_assert_function_defined sx_is_command
sxt_verify $? $FIXTURE_NAME "fn_sx_is_command_defined"

test_command_exist
sxt_verify $? $FIXTURE_NAME "test_command_exist"

test_command_not_exist
sxt_verify $? $FIXTURE_NAME "test_command_not_exist"
