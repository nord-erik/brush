#!/bin/env bash

# execute this script in order to test all tests
# when you add new test files, add them here

TEST_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
export TEST_ROOT
BRUSH_TEST_PRINTS_PASSES=$1

run_test() {
    local test_file=$1
    # shellcheck disable=SC1090
    (source "$TEST_ROOT/$test_file" 2> /dev/null) || printf "%s\n" "$test_file CRASHED!"
}

# source to keep it as one single process, meaning CI can check if it finished properly
source "$TEST_ROOT/base.sh" "$BRUSH_TEST_PRINTS_PASSES"
run_test logger_test.sh
run_test sweep_command_test.sh
run_test sweep_env_test.sh
run_test sweep_git_test.sh
run_test sweep_nok_test.sh
run_test sweep_ok_test.sh
run_test sweep_sudo_test.sh
run_test sweep_sudo_as_root_test.sh
