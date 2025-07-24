#!/bin/bash

TEST_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
export TEST_ROOT

# source to keep it as one process -- then || 0 to not crash on test failures
source "$TEST_ROOT"/log/test_log.sh || echo "log/test_log.sh CRASHED!"
source "$TEST_ROOT"/err/test_err.sh || echo "err/test_err.sh CRASHED!"
source "$TEST_ROOT"/guard/test_guard.sh || echo "guard/test_guard.sh CRASHED!"
source "$TEST_ROOT"/guard/test_guard_is_command.sh || echo "guard/test_guard_is_command.sh CRASHED!"
