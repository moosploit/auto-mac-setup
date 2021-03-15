#!/bin/bash
# ============================================================================
# -- File:          iterm/setup_iterm.sh
# -- Project:       auto-mac-setup
# -- Project URL:   https://github.com/moosploit/auto-mac-setup
# -- Create Date:   2020-08-28 13:06
# -- Author:        moosploit
# -- License:       MIT License | http://www.opensource.org/licenses/MIT
# ============================================================================

# Check whether the script is called directly or via source
if [[ $(basename ${0}) == $(basename ${BASH_SOURCE}) ]]; then
    source ../../../helper/output.sh
    source ../../../helper/utils.sh
    source ../../../helper/global_variables.sh
    project_dir_iterm="$ROOT_DIR"
else
    project_dir_iterm="$ROOT_DIR/src/config/iterm"
fi

# === Directory where the iTerm settings file should be stored === /
dotfiles_dir_iterm="$DOTFILES_DIR/iTerm"
# == Create new folder to store iTerm settings == /
mkdir -p "$dotfiles_dir_iterm" &>/dev/null

general_setup() {
    ask_for_confirmation "Should I setup iTerm now?"
    if ! answer_is_yes; then
        return 1
    fi

    copy_it_to "iTerm 2" "iTerm" "$project_dir_iterm"/com.googlecode.iterm2.plist.example "$dotfiles_dir_iterm"/com.googlecode.iterm2.plist

    # == iTerm > Settings > General > Preferences > Load preferences from a custom folder or URL [true|false] ==/
    defaults_write "iTerm 2" "com.googlecode.iterm2" "LoadPrefsFromCustomFolder" "bool" "true"

    # == iTerm > Settings > General > Preferences > Custom folder ==/
    defaults_write "iTerm 2" "com.googlecode.iterm2" "PrefsCustomFolder" "string" "$dotfiles_dir_iterm"

    # == iTerm > Settings > General > Preferences > Save changes to folder when iTerm2 quits [true|false] ==/
    defaults_write "iTerm 2" "com.googlecode.iterm2" "NoSyncNeverRemindPrefsChangesLostForFile_selection" "bool" "false"

    kill_app iTerm2
}

__init__() {
    print_cat "Setting up application iTerm!"
    general_setup
}

__init__
