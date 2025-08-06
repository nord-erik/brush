#!/bin/env bash

# env is used to make sure that passed variable name is set

sweep_env() {
    local env_var_name=$1

    test ${!env_var_name+1}
    sweep_ok $? "required env variable '$env_var_name' is not set!"
}
