#!/bin/env bash

# git is init makes sure that current working dir is part of init'ed git repo

sweep_git_is_init() {
  local is_init current_dir
  current_dir="$(pwd)"
  is_init="$(git rev-parse --is-inside-work-tree 2> /dev/null)"

  test "$is_init" == true
  sweep_ok $? "expected this to be a git repo: $current_dir"
}
