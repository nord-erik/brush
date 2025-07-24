#!/bin/bash

FIXTURE_NAME="test_guard"
source "$TEST_ROOT/test_base.sh"

# make sure err fns are defined
test_guard_function_is_defined() {
  local fn=$1

  sxt_assert_function_defined "$fn"
  sxt_verify $? $FIXTURE_NAME "fn_${fn}_defined"
}

test_guard_function_is_defined sx_is_file
