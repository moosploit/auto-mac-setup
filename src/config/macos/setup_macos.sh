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
if [[ $(basename ${0}) == $(basename ${BASH_SOURCE}) ]]; then
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
	defaults_write "Apple Dock" "com.apple.dock" "show-recents" "bool" "false"

	# == System Preferences > Mission Control > Group windows by application [true|false] ==/
	defaults_write "Apple Dock" "com.apple.dock" "expose-group-apps" "bool" "true"

	# == System Preferences > Mission Control > Automatically rearrange Spaces based on most recent use [true|false] ==/
	defaults_write "Apple Dock" "com.apple.dock" "mru-spaces" "bool" "false"

	kill_app Dock
}

apps_in_dock_setup() {

	ask_for_confirmation "May I rearrange your apps inside your dock?"
	if ! answer_is_yes; then
		return 1
	fi

	# == Wipe all application icons from the dock == /
	wipe_apps_from_dock "left"
	wipe_apps_from_dock "right"

	kill_app Dock

	add_app_to_dock "left" "ForkLift"
	add_app_to_dock "left" "iTerm"
	add_app_to_dock "left" "Spacer"

	add_app_to_dock "left" "Visual Studio Code"
	add_app_to_dock "left" "SnippetsLab"
	add_app_to_dock "left" "Sequel Pro"
	add_app_to_dock "left" "Insomnia"
	add_app_to_dock "left" "Spacer"

	add_app_to_dock "left" "Firefox"
	add_app_to_dock "left" "Google Chrome"
	add_app_to_dock "left" "Safari"
	add_app_to_dock "left" "Spacer"

	add_app_to_dock "left" "Adobe Lightroom Classic/Adobe Lightroom Classic"
	add_app_to_dock "left" "Adobe Photoshop 2020/Adobe Photoshop 2020"
	add_app_to_dock "left" "Adobe XD/Adobe XD"
	add_app_to_dock "left" "Affinity Photo"
	add_app_to_dock "left" "Affinity Designer"
	add_app_to_dock "left" "Spacer"

	add_app_to_dock "left" "Spotify"
	add_app_to_dock "left" "Plex"
	add_app_to_dock "left" "Spacer"

	add_app_to_dock "left" "Spark"
	add_app_to_dock "left" "Messages" "System"
	add_app_to_dock "left" "WhatsApp"
	add_app_to_dock "left" "Telegram"
	add_app_to_dock "left" "Signal"
	add_app_to_dock "left" "Discord"
	add_app_to_dock "left" "Spacer"

	add_app_to_dock "left" "Todoist"
	# add_app_to_dock "left" "Pages"
	# add_app_to_dock "left" "Numbers"
	add_app_to_dock "left" "PDFScanner"
	add_app_to_dock "left" "News Explorer"
	add_app_to_dock "left" "Spacer"

	add_app_to_dock "left" "VMware Fusion"
	add_app_to_dock "left" "VirtualBox"

	add_app_to_dock "right" "System Preferences" "System"
	add_app_to_dock "right" "AppCleaner"

	kill_app Dock
}

general_setup() {
	ask_for_confirmation "Should I setup the general settings now?"
	if ! answer_is_yes; then
		return 1
	fi

	# == System Preferences > General > Interface Style [Light|Dark] ==/
	defaults_write "General" "NSGlobalDomain" "AppleInterfaceStyle" "string" "Dark"

	# == System Preferences > General > Accent Color ==/
	# == [-1=Graphite|0=Red|1=Orange|2=Yellow|3=Green|4=Blue]5=Purple|6=Pink|7=]
	defaults_write "General" "NSGlobalDomain" "AppleAccentColor" "int" "1"

	# == System Preferences > General > Highlight Color ==/
	# == "0.968627 0.831373 1.000000 Purple"
	# == "1.000000 0.874510 0.701961 Orange"
	# == "1.000000 0.749020 0.823529 Pink"
	# == "1.000000 0.733333 0.721569 Red"
	# == "1.000000 0.937255 0.690196 Yellow"
	# == "0.752941 0.964706 0.678431 Green"
	# == "0.847059 0.847059 0.862745 Graphite"
	defaults_write "General" "NSGlobalDomain" "AppleInterfaceStyle" "string" "1.000000 0.874510 0.701961 Orange"

	# == System Preferences > General > Sidebar icon size [1=small|2=middle|3=great] ==/
	defaults_write "General" "NSGlobalDomain" "NSTableViewDefaultSizeMode" "int" "1"

	# == System Preferences > General > Show scrollbars [Automatic|WhenScrolling|Always] ==/
	defaults_write "General" "NSGlobalDomain" "AppleShowScrollBars" "string" "Always"

	# == System Preferences > Disable auto-correct [true|false] ==/
	defaults_write "General" "NSGlobalDomain" "NSAutomaticSpellingCorrectionEnabled" "bool" "false"

	# == System Preferences > Expand save panel by default [true|false] ==/
	defaults_write "General" "NSGlobalDomain" "NSNavPanelExpandedStateForSaveMode" "bool" "true"

	# == System Preferences > Expand print panel by default [true|false] ==/
	defaults_write "General" "NSGlobalDomain" "PMPrintingExpandedStateForPrint" "bool" "true"

	# == System Preferences > Save to disk by default, instead of iCloud [true|false] ==/
	defaults_write "General" "NSGlobalDomain" "NSDocumentSaveNewDocumentsToCloud" "bool" "false"

	# == System Preferences > Disable smart quotes when typing [true|false] ==/
	defaults_write "General" "NSGlobalDomain" "NSAutomaticQuoteSubstitutionEnabled" "bool" "false"

	# == System Preferences > Disable smart dashes when typing [true|false] ==/
	defaults_write "General" "NSGlobalDomain" "NSAutomaticDashSubstitutionEnabled" "bool" "false"

}

__init__() {
	ask_for_sudo

	# == Close all System Preference panes to prevent them to overriding our settings
	osascript -e 'tell application "System Preferences" to quit'

	print_cat "Setting up your computer name!"
	computer_name_setup

	print_cat "Setting up your dock!"
	dock_setup

	print_cat "Setting up the applications inside your dock!"
	apps_in_dock_setup

	print_cat "Setting up some general settings!"
	general_setup

}

__init__
