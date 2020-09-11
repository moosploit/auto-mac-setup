#!/bin/bash
# ================================================================================
# -- File:          macos/setup_macos.sh
# -- Project:       auto-mac-setup
# -- Project URL:   https://github.com/moosploit/auto-mac-setup
# -- Create Date:   2020-08-28 13:06
# -- Author:        Michael Linder
# -- Company:       moosploit.com
# -- License:       MIT License | http://www.opensource.org/licenses/MIT
# ================================================================================

# Check whether the script is called directly or via source
$(return &>/dev/null)

if [ "$?" -ne "0" ]; then
	source ../../../helper/output.sh
	source ../../../helper/utils.sh
fi

computer_name_setup() {

	local MAC_NAME=""

	ask_for_confirmation "Should I setup your computer name?"
	if ! answer_is_yes; then
		return 0
	fi

	while [[ -z $MAC_NAME ]]; do
		ask_for_input "How should I name your new Apple Mac?"
		MAC_NAME=$REPLY
	done

	scutil_set "ComputerName" "$MAC_NAME"
	scutil_set "HostName" "$MAC_NAME"
	scutil_set "LocalHostName" "$MAC_NAME"
	defaults_write "Apple SMB Server" "/Library/Preferences/SystemConfiguration/com.apple.smb.server" "NetBIOSName" "string" "$MAC_NAME"
}

dock_setup() {
	:
}

__init__() {
	ask_for_sudo

	# Close all System Preference panes to prevent them to overriding our settings
	osascript -e 'tell application "System Preferences" to quit'

	print_cat "First I will setup some general settings for your Apple Mac!"
	computer_name_setup

}

__init__
