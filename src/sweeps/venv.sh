#!/bin/env bash

# is_venv is used to make sure that shell has a python venv
# which is assumed to be true if $VIRTUAL_ENV is non-empty

sweep_is_venv() {
    local current_venv_var="VIRTUAL_ENV"
    test ${!current_venv_var+1}
    sweep_ok $? "you are not in a virtual python evnironment, please make sure you are"
    test -n "$VIRTUAL_ENV"
    sweep_ok $? "you are not in a virtual python evnironment, please make sure you are"
}
