#!/bin/bash

# execute this script in order to test all tests
# when you add new test files, add them here

TEST_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
export TEST_ROOT

include() {
  local test_file=$1
  # shellcheck disable=SC1090
  source "$TEST_ROOT/$test_file" || echo "$test_file CRASHED!"
}

# source to keep it as one process -- then || 0 to not crash on test failures
include logger_test.sh
include sweep_command_test.sh
include sweep_ok_test.sh
