#!/bin/bash

# execute this script in order to test all tests
# when you add new test files, add them here

TEST_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
export TEST_ROOT

run_test() {
  local test_file=$1
  # shellcheck disable=SC1090
  source "$TEST_ROOT/$test_file" 2> /dev/null || echo "$test_file CRASHED!"
}

# source to keep it as one process -- then || 0 to not crash on test failures
run_test logger_test.sh
run_test sweep_command_test.sh
run_test sweep_env_test.sh
run_test sweep_nok_test.sh
run_test sweep_ok_test.sh
run_test sweep_sudo_test.sh
run_test sweep_sudo_as_root_test.sh
