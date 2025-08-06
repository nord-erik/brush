#!/bin/env bash

# sweep_sudo checks if the user is root, for when that is required
# can also assert that it should not be root

sweep_sudo() {
    local should_be=$1
    local is_root final_app_name

    # error message
    if [ "$BRUSH_APP_NAME" = "bru.sh" ]; then
        final_app_name="this script"
    else
        final_app_name="'$BRUSH_APP_NAME'"
    fi

    # default argument 1 value
    if [ -z "$should_be" ]; then
        should_be=true
    fi

    # validity check argument 1
    if [ "$should_be" = "true" ] || [ "$should_be" = "false" ]; then
        true
    else
        brush_error "sweep_sudo optional 1st argument must be omitted, true or false"
        exit 1
    fi

    # actual logic to determine if OK -- first stringify the "id -u"
    if [ "$(id -u)" -eq 0 ]; then
        is_root="true"
    else
        is_root="false"
    fi

    case $is_root in
        true)
            if [ "$should_be" = "true" ]; then
                return 0
            fi

            brush_error "you must be user in order to run $final_app_name, please re-run without root"
            ;;
        false)
            if [ "$should_be" != "true" ]; then
                return 0
            fi

            brush_error "you must be root in order to run $final_app_name, please re-run with sudo"
            ;;
        *)
            brush_error "unexpected case of quantum root"
            ;;
    esac

    exit 1
}
