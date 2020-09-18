#!/bin/bash
# ================================================================================
# -- File:          iterm/setup_iterm.sh
# -- Project:       auto-mac-setup
# -- Project URL:   https://github.com/moosploit/auto-mac-setup
# -- Create Date:   2020-08-28 13:06
# -- Author:        Michael Linder
# -- Company:       moosploit.com
# -- License:       MIT License | http://www.opensource.org/licenses/MIT
# ================================================================================

# Check whether the script is called directly or via source
if [[ $(basename ${0}) == $(basename ${BASH_SOURCE}) ]]; then
	source ../../../helper/output.sh
	source ../../../helper/utils.sh
	ROOT_DIR=$(pwd -P)
else
	ROOT_DIR="$ROOT_DIR/src/config/iterm"
fi

general_setup() {
	ask_for_confirmation "Should I setup iTerm now?"
	if ! answer_is_yes; then
		return 1
	fi
	cp "$ROOT_DIR"/com.googlecode.iterm2.plist.example "$ROOT_DIR"/com.googlecode.iterm2.plist

	# == iTerm > Settings > General > Preferences > Load preferences from a custom folder or URL [true|false] ==/
	defaults_write "iTerm 2" "com.googlecode.iterm2" "LoadPrefsFromCustomFolder" "bool" "true"

	# == iTerm > Settings > General > Preferences > Custom folder ==/
	defaults_write "iTerm 2" "com.googlecode.iterm2" "PrefsCustomFolder" "string" "$ROOT_DIR"

	# == iTerm > Settings > General > Preferences > Save changes to folder when iTerm2 quits [true|false] ==/
	defaults_write "iTerm 2" "com.googlecode.iterm2" "NoSyncNeverRemindPrefsChangesLostForFile_selection" "bool" "false"

	kill_app iTerm iTerm2
}

__init__() {

	print_cat "Setting up application iTerm!"
	general_setup
}

__init__
