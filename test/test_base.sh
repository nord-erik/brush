#!/bin/bash

source "$TEST_ROOT/../sx/shmoo.sh"

sxt_verify() {
  code=$1
  test_file_name=$2
  test_name=$3

  if [ "$code" != "0" ]; then
    echo "FAIL    ::::    $test_file_name # $test_name"
  else
    echo "ok $test_file_name # $test_name"
  fi
}

sxt_assert_function_defined() {
  fn=$1

  if [ "$(type -t "$fn")" = "function" ]; then
    return 0
  fi

  return 1
}
