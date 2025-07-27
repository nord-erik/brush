#!/bin/bash
# shellcheck disable=SC2319

FIXTURE_NAME="sweep_root"
source "$TEST_ROOT/base.sh"
echo "${BRUSH_CYAN}RUN_TEST${BRUSH_CLEAR}: $FIXTURE_NAME"

mock_root() {
  return 0
}

# verify api can load
brush_defined sweep_root
brush_assert $? $FIXTURE_NAME "sweep_root_defined"

(sweep_root) # capture the exit
test $? -eq 1
brush_assert $? $FIXTURE_NAME "exits_when_not_root"

if sudo -nv 2> /dev/null; then
  (sudo bash -c "$(declare -f sweep_root); sweep_root") # capture the exit
  brush_assert $? $FIXTURE_NAME "nothing_happens_when_root"
else
  brush_skip $FIXTURE_NAME "nothing_happens_when_root"
fi
