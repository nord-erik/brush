#!/bin/bash
# shellcheck disable=SC2319

FIXTURE_NAME="sweep_root"
source "$TEST_ROOT/base.sh"
echo "${BRUSH_CYAN}RUN_TEST${BRUSH_CLEAR}: $FIXTURE_NAME"

mock_root() {
  return 0
}

# verify api can load and argument guard
brush_defined sweep_root
brush_assert $? $FIXTURE_NAME "sweep_root_defined"

# verify cases when not root
(
  sweep_root error
  return 0
) # capture the exit
test $? -eq 1
brush_assert $? $FIXTURE_NAME "sweep_root_argument_validity_error"

(
  sweep_root
  return 0
) # capture the exit
test $? -eq 1
brush_assert $? $FIXTURE_NAME "sweep_root_exit_when_not_root_but_should_implicit"
(
  sweep_root true
  return 0
) # capture the exit
test $? -eq 1
brush_assert $? $FIXTURE_NAME "sweep_root_exit_when_not_root_but_should_explicit"

sweep_root false
brush_assert $? $FIXTURE_NAME "sweep_root_return_when_not_root_and_should_not"

# verify cases when is root
# returns 0 if there are cached sudo credentials and can sudo without user intervention...
can_sudo() {
  sudo -nv 2> /dev/null
  return $?
}

if can_sudo; then
  # pass along brush_error and sweep_root to child process
  (sudo bash -c "$(declare -f __brush_system_logger); $(declare -f __brush_terminal_print); $(declare -f brush_error); $(declare -f sweep_root); sweep_root") # capture the exit
  brush_assert $? $FIXTURE_NAME "sweep_root_returns_when_is_root"
else
  brush_skip $FIXTURE_NAME "sweep_root_returns_when_is_root"
fi

if can_sudo; then
  # pass along brush_error and sweep_root to child process
  (
    sudo bash -c "$(declare -f __brush_system_logger); $(declare -f __brush_terminal_print); $(declare -f brush_error); $(declare -f sweep_root); sweep_root false"
    return $?
  ) # capture the exit
  test $? -eq 1
  brush_assert $? $FIXTURE_NAME "sweep_root_exits_when_is_root_but_should_not"
else
  brush_skip $FIXTURE_NAME "sweep_root_exits_when_is_root_but_should_not"
fi

return 0
