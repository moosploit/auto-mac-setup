#!/bin/bash
# ================================================================================
# -- File:          moom/setup_moom.sh
# -- Project:       auto-mac-setup
# -- Project URL:   https://github.com/moosploit/auto-mac-setup
# -- Create Date:   2020-09-16 21:39
# -- Author:        Michael Linder
# -- Company:       moosploit.com
# -- License:       MIT License | http://www.opensource.org/licenses/MIT
# ================================================================================

# Check whether the script is called directly or via source
if [[ $(basename ${0}) == $(basename ${BASH_SOURCE}) ]]; then
	source ../../../helper/output.sh
	source ../../../helper/utils.sh
	source ../../../helper/global_variables.sh
	MOOM_DIR="$ROOT_DIR"
else
	MOOM_DIR="$ROOT_DIR/src/config/moom"
fi

general_setup() {
	local PLIST_FILE=""

	ask_for_confirmation "Should I use the default plist file?"
	if ! answer_is_yes; then
		while [[ -z $PLIST_FILE ]]; do
			ask_for_input "Ok, please provide the absolute path to your plist file"
			if [[ -n "$REPLY" && -e "$REPLY" ]]; then
				PLIST_FILE="$REPLY"
			else
				print_fail "Your provided plist file doesn't exist!"
			fi
		done
	else
		# == Path to the default plist file
		PLIST_FILE="$MOOM_DIR/com.manytricks.Moom.plist.example"
	fi

	kill_app Moom
	plist_import "Moom" "$PLIST_FILE" "com.manytricks.Moom"
	open -a Moom
}

__init__() {

	print_cat "Setting up application Moom!"
	general_setup
}

__init__
