#!/bin/bash
# shellcheck disable=SC2319

# tests the whole git addon -- to let all sweeps use the same tmp file structure

FIXTURE_NAME="sweep_git"
printf "%s\n" "${BRUSH_CYAN}RUN_TEST${BRUSH_CLEAR}: $FIXTURE_NAME"

declare -A temporary_git_paths
source "$TEST_ROOT/sweep_git_test_fixture.sh"

# make sure we have git and mktemp...
sweep_command git mktemp

# verify api can load
brush_defined sweep_git_is_clean
brush_assert $? $FIXTURE_NAME "sweep_git_is_clean"

brush_defined sweep_git_is_init
brush_assert $? $FIXTURE_NAME "sweep_git_is_init"

brush_defined sweep_git_is_on
brush_assert $? $FIXTURE_NAME "sweep_git_is_on"

setup_file_tree

# test is_init negative
(
  cd "${temporary_git_paths[no_git_repo]}" || return 0
  sweep_git_is_init
)
test $? -eq 1
brush_assert $? $FIXTURE_NAME "sweep_git_is_init_when_not"

# test is_init positives
for key in "${!temporary_git_paths[@]}"; do
  if [ "$key" != "no_git_repo" ]; then
    (
      cd "${temporary_git_paths[$key]}" || return 1
      sweep_git_is_init
    )
    brush_assert $? $FIXTURE_NAME "sweep_git_is_init[$key]"
  fi
done

# test is_clean negative
(
  cd "${temporary_git_paths[a_git_repo_dirty]}" || return 0
  sweep_git_is_clean
)
test $? -eq 1
brush_assert $? $FIXTURE_NAME "sweep_git_is_clean_when_not"

# test is_clean positives
for key in "${!temporary_git_paths[@]}"; do
  if [ "$key" != "a_git_repo_dirty" ]; then
    (
      cd "${temporary_git_paths[$key]}" || return 1
      sweep_git_is_clean
    )
    brush_assert $? $FIXTURE_NAME "sweep_git_is_clean[$key]"
  fi
done

# test is_on negative
(
  cd "${temporary_git_paths[a_git_repo_with_branches]}" || return 0
  sweep_git_is_on trunk
)
test $? -eq 1
brush_assert $? $FIXTURE_NAME "swee_git_is_on_when_not"

# test is_on positives
for key in "${!temporary_git_paths[@]}"; do
  if [ "$key" != "a_git_repo_with_branches" ]; then
    (
      cd "${temporary_git_paths[$key]}" || return 1
      sweep_git_is_on trunk
    )
    brush_assert $? $FIXTURE_NAME "sweep_git_is_on[$key]"
  fi
done

tear_down_file_tree
