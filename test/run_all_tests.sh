#!/bin/bash

TEST_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
export TEST_ROOT

"$TEST_ROOT"/log/test_log.sh
"$TEST_ROOT"/err/test_err.sh

