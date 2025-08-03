#!/bin/env bash

declare -A temporary_git_paths

# because of mac vs linux differences we need to try twice
# linux version first, if that fails (because we are on mac), then do mac version
_create_temporary_dir() {
  local created_dir
  created_dir=$(mktemp -d 2> /dev/null || mktemp -d -t 'mytmpdir')
  printf "%s\n" "$created_dir"
}

setup_file_tree() {
  temporary_git_paths[no_git_repo]=$(_create_temporary_dir)
  temporary_git_paths[a_git_repo]=$(_create_temporary_dir)
  temporary_git_paths[a_git_repo_dirty]=$(_create_temporary_dir)
  temporary_git_paths[a_git_repo_with_branches]=$(_create_temporary_dir)
  # temporary_git_paths[a_git_repo_with_merge_confict]=$(_create_temporary_dir)
  # temporary_git_paths[a_git_repo_with_rebase_flow]=$(_create_temporary_dir)

  for key in "${!temporary_git_paths[@]}"; do
    # create a hello world file in all paths
    cat > "${temporary_git_paths[$key]}/main.c" << EOF
#include <stdio.h>

int main() {
    printf("Hello, world!\\n");
    return 0;
}
EOF
    # only create git repos for those that expect it
    if [ "$key" != "no_git_repo" ]; then
      # do it in sub-process to not cd this parent process
      (
        cd "${temporary_git_paths[$key]}" || return
        git init --initial-branch=trunk --quiet
        git add main.c
        git commit --message="initial commit" --quiet
      )
    fi

    # only branch out in git repos that expect it
    if [ "$key" != "no_git_repo" ] && [ "$key" != "a_git_repo" ] && [ "$key" != "a_git_repo_dirty" ]; then
      # do it in sub-process to not cd this parent process
      (
        cd "${temporary_git_paths[$key]}" || return
        git checkout -b other
      )
    fi

    if [ "$key" == "a_git_repo_dirty" ]; then
      # do it in sub-process to not cd this parent process
      (
        cd "${temporary_git_paths[$key]}" || return
        sed --in-place 's/world/change/' main.c
      )
    fi
  done
}

tear_down_file_tree() {
  for key in "${!temporary_git_paths[@]}"; do
    rm -rf "${temporary_git_paths[$key]}"
  done
}
