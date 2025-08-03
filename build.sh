#!/bin/env bash
# shellcheck disable=SC2016

# builds brush and outputs 'bru.sh'
REPO_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
cd "$REPO_ROOT" || exit 112

# see... brush is very handy now I need to make a small error func
build_error() {
  local message=$1

  printf "%b%s%b %s\n" $'\033[31m' "error:" $'\033[0m' "$message"
}

build() {
  local repo_root=$1
  local build_brush_root build_sweeps_root build_sources source_file source_file_relative_path
  build_brush_root=$repo_root/src
  build_sweeps_root=$repo_root/src/sweeps

  rm -rf bru.sh
  touch bru.sh
  chmod 644 bru.sh

  # populate the file
  grep -v -E "^#[^\!]|^#$|^$" src/brush.sh |                   # grep non-comments, non-empty lines. include shebang
    sed '/BRUSH_ROOT=/a BRUSH_ROOT="$BRUSH_ROOT/src"' > bru.sh # correct root variables by injecting "src"

  # expand sources to be static
  # shellcheck disable=SC2207
  build_sources=($(grep "source" bru.sh | awk '{print $2}'))

  for source_file in "${build_sources[@]}"; do
    source_file_relative_path=""

    if [[ "$source_file" == *"BRUSH_ROOT"* ]]; then
      source_file_relative_path="${source_file:13:-1}"
      source_file_relative_path="$build_brush_root/$source_file_relative_path"
    fi

    if [[ "$source_file" == *"SWEEPS_ROOT"* ]]; then
      source_file_relative_path="${source_file:14:-1}"
      source_file_relative_path="$build_sweeps_root/$source_file_relative_path"
    fi

    if [ -n "$source_file_relative_path" ]; then
      grep -v -E "^\s*#|^$" "$source_file_relative_path" >> bru.sh
    else
      build_error "unknown source file $source_file quitting..."
      exit 1
    fi
  done

  if ! sed -i '/^\(source\|unset\|BRUSH_ROOT\|SWEEPS_ROOT\)/d' bru.sh; then
    return 1
  fi

  shfmt --write --minify bru.sh
}

if build "$REPO_ROOT"; then
  printf "%b%s%b %s\n" $'\033[92m' "success:" $'\033[0m' "build all OK"
else
  build_error "something went wrong with the build, please inspect bru.sh"
fi
