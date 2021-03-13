#!/bin/bash
# ============================================================================
# -- File:          moom/setup_moom.sh
# -- Project:       auto-mac-setup
# -- Project URL:   https://github.com/moosploit/auto-mac-setup
# -- Create Date:   2020-09-16 21:39
# -- Author:        moosploit
# -- License:       MIT License | http://www.opensource.org/licenses/MIT
# ============================================================================

# Check whether the script is called directly or via source
if [[ $(basename ${0}) == $(basename ${BASH_SOURCE}) ]]; then
    source ../../../helper/output.sh
    source ../../../helper/utils.sh
    source ../../../helper/global_variables.sh
    project_dir_moom="$ROOT_DIR"
else
    project_dir_moom="$ROOT_DIR/src/setup/moom"
fi

general_setup() {
    local plist_file_moom=""

    ask_for_confirmation "Should I use the default plist file?"
    if ! answer_is_yes; then
        while [[ -z $plist_file_moom ]]; do
            ask_for_input "Ok, please provide the absolute path to your plist file"
            if [[ -n "$REPLY" && -e "$REPLY" ]]; then
                plist_file_moom="$REPLY"
            else
                print_fail "Your provided plist file doesn't exist!"
            fi
        done
    else
        # == Path to the default plist file
        plist_file_moom="$project_dir_moom/com.manytricks.Moom.plist.example"
    fi

    kill_app Moom
    plist_import "Moom" "$plist_file_moom" "com.manytricks.Moom"
    open -a Moom
}

__init__() {
    print_cat "Setting up application Moom!"
    general_setup
}

__init__
