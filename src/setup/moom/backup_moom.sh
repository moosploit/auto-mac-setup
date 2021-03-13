#!/bin/bash
# ============================================================================
# -- File:          moom/backup_moom.sh
# -- Project:       auto-mac-setup
# -- Project URL:   https://github.com/moosploit/auto-mac-setup
# -- Create Date:   2021-03-13 23:57
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

backup_plist_moom() {
    local plist_file_moom="$project_dir_moom/com.manytricks.Moom.plist.example"

    ask_for_confirmation "Should I backup current moom configuration plist file?"
    if answer_is_yes; then
        kill_app Moom
        plist_export "Moom" "$plist_file_moom" "com.manytricks.Moom"
        open -a Moom
    fi
}

__init__() {
    print_cat "Backing up current moom configuration."
    backup_plist_moom
}

__init__
