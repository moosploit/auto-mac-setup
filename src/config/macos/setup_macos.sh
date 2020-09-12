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
		return 1
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

	ask_for_confirmation "Should I setup your dock?"
	if ! answer_is_yes; then
		return 1
	fi

	# == System Preferences > Dock > Size ==/
	defaults_write "Apple Dock" "com.apple.dock" "tilesize" "float" "36"

	# == System Preferences > Dock > Magnification [true|false] ==/
	defaults_write "Apple Dock" "com.apple.dock" "magnification" "bool" "true"

	# == System Preferences > Dock > Magnified Size ==/
	defaults_write "Apple Dock" "com.apple.dock" "largesize" "float" "70"

	# == System Preferences > Dock > Screen orientation [left|bottom|right] ==/
	defaults_write "Apple Dock" "com.apple.dock" "orientation" "string" "bottom"

	# System Preferences > Dock > Minimize windows using [genie|scale] ==/
	defaults_write "Apple Dock" "com.apple.dock" "mineffect" "string" "genie"

	# == System Preferences > Dock > Minimize windows into application icon [true|false] ==/
	defaults_write "Apple Dock" "com.apple.dock" "minimize-to-application" "bool" "true"

	# == System Preferences > Dock > Animate application launch [true|false] ==/
	defaults_write "Apple Dock" "com.apple.dock" "launchanim" "bool" "true"

	# == System Preferences > Dock > Automatically hide and show the Dock [true|false] ==/
	defaults_write "Apple Dock" "com.apple.dock" "autohide" "bool" "true"

	# == System Preferences > Dock > Automatically hide and show the Dock (Delay) ==/
	defaults_write "Apple Dock" "com.apple.dock" "autohide-delay" "float" "0"

	# == System Preferences > Dock > Automatically hide and show the Dock (Duration) ==/
	defaults_write "Apple Dock" "com.apple.dock" "autohide-time-modifier" "float" "0.5"

	# == System Preferences > Dock > Show indicators for open applications [true|false] ==/
	defaults_write "Apple Dock" "com.apple.dock" "show-process-indicators" "bool" "true"

	# == System Preferences > Dock > Show recent applications in Dock [true|false] ==/
	defaults_write "Apple Dock" "com.apple.dock" "show-recents" "bool" "true"

	# == System Preferences > Mission Control > Group windows by application [true|false] ==/
	defaults_write "Apple Dock" "com.apple.dock" "expose-group-apps" "bool" "true"

	# == System Preferences > Mission Control > Automatically rearrange Spaces based on most recent use [true|false] ==/
	defaults_write "Apple Dock" "com.apple.dock" "mru-spaces" "bool" "false"

	ask_for_confirmation "May I rearrange your apps inside your dock?"
	if answer_is_yes; then
		# == Wipe all application icons from the dock == /
		defaults write com.apple.dock persistent-apps -array
		defaults write com.apple.dock persistent-others -array

		# == Add application Forklift to the dock == /
		defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/ForkLift.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
		# == Add application iTerm2 to the dock == /
		defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/iTerm.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'

		# == Add a spacer to the left side of the Dock (where the applications are) == /
		defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'

		# == Add application Firefox to the dock == /
		defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Firefox.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
		# == Add application Google Chrome to the dock == /
		defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Google Chrome.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'

		# == Add a spacer to the left side of the Dock (where the applications are) == /
		defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'

		# == Add application Visual Studio Code to the dock == /
		defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Visual Studio Code.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
		# == Add application Sequel Pro to the dock == /
		defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Sequel Pro.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'

		# == Add a spacer to the left side of the Dock (where the applications are) == /
		defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'

		# == Add application Adobe Lightroom Classic to the dock == /
		defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Adobe Lightroom Classic/Adobe Lightroom Classic.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
		# == Add application Adobe Photoshop 2020 to the dock == /
		defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Adobe Photoshop 2020/Adobe Photoshop 2020.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
		# == Add application Affinity Photo to the dock == /
		defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Affinity Photo.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
		# == Add application Affinity Designer to the dock == /
		defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Affinity Designer.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'

		# == Add a spacer to the left side of the Dock (where the applications are) == /
		defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'

		# == Add application Spotify to the dock == /
		defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Spotify.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
		# == Add application Plex to the dock == /
		defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Plex.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'

		# == Add a spacer to the left side of the Dock (where the applications are) == /
		defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'

		# == Add application Spark to the dock == /
		defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Spark.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
		# == Add application WhatsApp to the dock == /
		defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/WhatsApp.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
		# == Add application Telegram to the dock == /
		defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Telegram.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
		# == Add application Signal to the dock == /
		defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Signal.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
		# == Add application Discord to the dock == /
		defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Discord.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'

		# == Add a spacer to the left side of the Dock (where the applications are) == /
		defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'

		# == Add application Todoist to the dock == /
		defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Todoist.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
		# == Add application Pages to the dock == /
		defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Pages.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
		# == Add application Numbers to the dock == /
		defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Numbers.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
		# == Add application PDFScanner to the dock == /
		defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/PDFScanner.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
		# == Add application News Explorer to the dock == /
		defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/News Explorer.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'

		# == Add a spacer to the left side of the Dock (where the applications are) == /
		defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'

		# == Add application VMware Fusion to the dock == /
		defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/VMware Fusion.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
		# == Add application VirtualBox to the dock == /
		defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/VirtualBox.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'

		# ====================================================================== /
		# == Add application System Preferences to the dock on the right side == /
		defaults write com.apple.dock persistent-others -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/System/Applications/System Preferences.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'

		# == Add a spacer to the right side of the Dock (where the Trash is) == /
		# defaults write com.apple.dock persistent-others -array-add '{tile-data={}; tile-type="spacer-tile";}'
	fi
	kill_app Dock
}

__init__() {
	ask_for_sudo

	# == Close all System Preference panes to prevent them to overriding our settings
	osascript -e 'tell application "System Preferences" to quit'

	print_cat "First we will set up your computer name!"
	computer_name_setup

	print_cat "We are setting up your dock now!"
	dock_setup

}

__init__
