#!/bin/env bash

# git is clean makes sure that you are on a clean working state

sweep_git_is_clean() {
    local git_status

    sweep_git_is_init
    git_status="$(git status --porcelain)" && test -z "$git_status"
    sweep_ok $? "expected git repo to be clean: $(pwd)"
}
