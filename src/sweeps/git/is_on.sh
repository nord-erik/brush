#!/bin/env bash

# git is in makes sure that you are checked in on a specific branch

sweep_git_is_on() {
  local expected_branch=$1
  local current_branch current_dir

  test -z "$current_branch"
  sweep_ok $? "you must pass an expected branch name to 'sweep_git_is_on'"

  current_dir="$(pwd)"
  sweep_git_is_init

  current_branch="$(git rev-parse --abbrev-ref HEAD)"
  test "$current_branch" == "$expected_branch"
  sweep_ok $? "expected branch '$expected_branch' but was '$current_branch' in git: $current_dir"
}
