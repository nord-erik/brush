#!/bin/bash

FIXTURE_NAME="test_err"
source "$TEST_ROOT/test_base.sh"

# make sure err fns are defined
test_err_function_is_defined() {
  fn=$1

  sxt_assert_function_defined "$fn"
  sxt_verify $? $FIXTURE_NAME "fn_${fn}_defined"
}

test_err_function_is_defined check
test_err_function_is_defined try
