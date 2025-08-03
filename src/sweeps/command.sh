#!/bin/env bash

# use this sweep when you need to make sure that the context has a specific command

sweep_command() {
  local cmd=$1

  command -v "$cmd" > /dev/null 2>&1
  sweep_ok $? "required command '$cmd' not found"
}
