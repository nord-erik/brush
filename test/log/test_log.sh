#!/bin/bash

FIXTURE_NAME="test_log"
source "$TEST_ROOT/test_base.sh"

# make sure log fns are defined
test_log_function_is_defined() {
  fn=$1

  sxt_assert_function_defined "$fn"
  sxt_verify $? $FIXTURE_NAME "fn_${fn}_defined"
}

test_log_function_is_defined sx_error
test_log_function_is_defined sx_info
test_log_function_is_defined sx_log
test_log_function_is_defined sx_warn
