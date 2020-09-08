#!/bin/bash
# ================================================================================
# -- File:          homebrew/brew_install.sh
# -- Project:       auto-mac-setup
# -- Project URL:   https://github.com/moosploit/auto-mac-setup
# -- Create Date:   2020-08-28 13:07
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

opt_out_of_analaytics() {

	if [[ "$(git config --file="$(brew --repository)/.git/config" --get homebrew.analyticsdisabled)" != "true" ]]; then
		print_run "Opting out of Homebrews analytics!"

		# git config --file="$(brew --repository)/.git/config" --replace-all homebrew.analyticsdisabled true
		brew analytics off
		print_result $? "Opt-Out of Homebrew analytics"
	else
		print_success "Already opt-out of Homebrews analytics!"
	fi
}

install_homebrew() {
	if ! check_cmd_exists "brew"; then
		print_run "Starting to install Homebrew package manager for macOS!"

		printf "\n" | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" &>/dev/null
		#	└─	simulate the ENTER keypress

		print_result $? "Homebrew installation."
	else
		print_success "Homebrew is already installed!"
	fi
}

__init__() {
	ask_for_sudo

	print_cat "Now we will install 'Homebrew' the missing package manager for macOS!"
	install_homebrew

	print_cat "Beacuse we don't like analytics about our behaviours!"
	opt_out_of_analaytics
}

__init__
