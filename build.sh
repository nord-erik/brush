#!/bin/env bash
# shellcheck disable=SC2016

# builds brush and outputs 'bru.sh'
REPO_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
cd "$REPO_ROOT" || exit 112
source "$REPO_ROOT/src/brush.sh"

_clear_build() {
    rm -rf bru.sh
    touch bru.sh
    chmod 644 bru.sh
    return $?
}

_collect_brush() {
    # populate the file...
    # grep non-comments, non-empty lines. include shebang
    grep -v -E "^#[^\!]|^#$|^$" src/brush.sh \
        | sed '/BRUSH_ROOT=/a BRUSH_ROOT="$BRUSH_ROOT/src"' > bru.sh # correct root variables by injecting "src"
}

_staticalise_sources() {
    local repo_root=$1
    local build_brush_root build_sweeps_root build_sources build_sources_array source_file source_file_relative_path

    build_brush_root=$repo_root/src
    build_sweeps_root=$repo_root/src/sweeps
    build_sources=$(grep "source" bru.sh)
    sweep_ok $? "staticalise_sources cannot find any sources"

    # shellcheck disable=SC2207
    build_sources_array=($(echo "$build_sources" | awk '{print $2}'))

    for source_file in "${build_sources_array[@]}"; do
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
            brush_error "staticalise_sources found unknown source file $source_file quitting..."
            return 1
        fi
    done

    if ! sed -i '/^\(source\|unset\|BRUSH_ROOT\|SWEEPS_ROOT\)/d' bru.sh; then
        return 1
    fi
}

_minify_source() {
    shfmt --write --minify bru.sh
}

_compress_export() {
    local export_statements export_statements_array

    export_statements=$(grep -E "^export " bru.sh)
    sweep_ok $? "compress_exports did not find any exports"

    # awk for all but first column (which is grepped to be 'export')
    # shellcheck disable=SC2207
    export_statements_array=($(echo "$export_statements" | awk '{for (i=2; i<NF; i++) printf $i " "; print $NF}'))

    if ! sed -i '/^\(export \)/d' bru.sh; then
        return 1
    fi

    printf "export %s\n" "${export_statements_array[*]}" >> bru.sh
}

build() {
    local repo_root=$1

    _clear_build
    sweep_ok $? "build failed on clear build"
    _collect_brush
    sweep_ok $? "build failed on collect brush"
    _staticalise_sources "$repo_root"
    sweep_ok $? "build failed on staticalisation of sources"
    _minify_source
    sweep_ok $? "build failed on minify step"
    _compress_export
    sweep_ok $? "build failed on compress exports"
}

if build "$REPO_ROOT"; then
    printf "%b%s%b %s\n" "$BRUSH_LIGHT_GREEN" "success:" "$BRUSH_CLEAR" "build all OK"
else
    brush_error "something went wrong with the build, please inspect bru.sh"
fi
