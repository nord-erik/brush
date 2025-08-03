#!/bin/env bash

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
brush_assert $? $FIXTURE_NAME "sweep_git_is_not_init"

# test is_init positives
(
  cd "${temporary_git_paths[a_git_repo]}" || return 1
  sweep_git_is_init
)
brush_assert $? $FIXTURE_NAME "sweep_git_is_init[a_git_repo]"
(
  cd "${temporary_git_paths[a_git_repo_dirty]}" || return 1
  sweep_git_is_init
)
brush_assert $? $FIXTURE_NAME "sweep_git_is_init[a_git_repo_dirty]"
(
  cd "${temporary_git_paths[a_git_repo_with_branches]}" || return 1
  sweep_git_is_init
)
brush_assert $? $FIXTURE_NAME "sweep_git_is_init[a_git_repo_with_branches]"

# test is_clean negative
(
  cd "${temporary_git_paths[a_git_repo_dirty]}" || return 0
  sweep_git_is_clean
)
test $? -eq 1
brush_assert $? $FIXTURE_NAME "sweep_git_not_clean"

(
  cd "${temporary_git_paths[no_git_repo]}" || return 0
  sweep_git_is_clean
)
test $? -eq 1
brush_assert $? $FIXTURE_NAME "sweep_git_not_clean_when_non_git"

# test is_clean positives
(
  cd "${temporary_git_paths[a_git_repo]}" || return 1
  sweep_git_is_clean
)
brush_assert $? $FIXTURE_NAME "sweep_git_is_clean[a_git_repo]"
(
  cd "${temporary_git_paths[a_git_repo_with_branches]}" || return 1
  sweep_git_is_clean
)
brush_assert $? $FIXTURE_NAME "sweep_git_is_clean[a_git_repo_with_branches]"

# test is_on negatives
(
  sweep_git_is_on
)
test $? -eq 1
brush_assert $? $FIXTURE_NAME "sweep_git_is_on_invalid_argument"
(
  cd "${temporary_git_paths[a_git_repo_with_branches]}" || return 0
  sweep_git_is_on trunk
)
test $? -eq 1
brush_assert $? $FIXTURE_NAME "sweep_git_is_not_on"
(
  cd "${temporary_git_paths[no_git_repo]}" || return 0
  sweep_git_is_on trunk
)
test $? -eq 1
brush_assert $? $FIXTURE_NAME "sweep_git_is_on_when_non_git"

# test is_on positives
(
  cd "${temporary_git_paths[a_git_repo]}" || return 1
  sweep_git_is_on trunk
)
brush_assert $? $FIXTURE_NAME "sweep_git_is_on[a_git_repo]"
(
  cd "${temporary_git_paths[a_git_repo_dirty]}" || return 1
  sweep_git_is_on trunk
)
brush_assert $? $FIXTURE_NAME "sweep_git_is_on[a_git_repo_dirty]"

tear_down_file_tree
