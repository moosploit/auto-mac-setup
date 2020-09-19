#!/bin/bash
# ================================================================================
# -- File:          auto-mac-setup/setup.sh
# -- Project:       auto-mac-setup
# -- Project URL:   https://github.com/moosploit/auto-mac-setup
# -- Create Date:   2020-08-28 11:58
# -- Author:        Michael Linder
# -- Company:       moosploit.com
# -- License:       MIT License | http://www.opensource.org/licenses/MIT
# ================================================================================

source ./helper/utils.sh
source ./helper/output.sh
source ./helper/global_variables.sh

__init__() {
	print_cat "Meow $(get_full_username)!" "I will help you to auto configure your new Apple Mac."
	ask_for_confirmation "Shall we procced?"

	if ! answer_is_yes; then
		print_cat "OK! Hope you'll come back soon."
		exit
	fi

	print_cat "Purrrrrrfect! - Let us begin."

	# === Install Xcode and Xcode Development Tools === /
	source ./src/install/xcode/xcode_install.sh

	# === Install Applications via Homebrew === /
	source ./src/install/homebrew/brew_install.sh

	# === Install Applications via Mac App Store === /
	source ./src/install/mas/mas_install.sh

	# === Configure macOS === /
	source ./src/config/macos/setup_macos.sh

	# === Configure Application ForkLift 3 === /
	source ./src/config/forklift/setup_forklift.sh

	# === Configure Application Moom === /
	source ./src/config/moom/setup_moom.sh

	# === Configure Application Iterm2 === /
	source ./src/config/iterm/setup_iterm.sh

	# === Configure Application Visual Studio Code === /
	source ./src/config/vscode/setup_vscode.sh
}

__init__
