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
		print_run "Opting out of 'Homebrew' analytics!"

		# git config --file="$(brew --repository)/.git/config" --replace-all homebrew.analyticsdisabled true
		brew analytics off
		print_result $? "Opt-Out of 'Homebrew' analytics"
	else
		print_success "Already opt-out of 'Homebrew' analytics!"
	fi
}

install_homebrew() {
	if ! check_cmd_exists "brew"; then
		print_run "Starting to install Homebrew package manager for macOS!"

		printf "\n" | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" &>/dev/null
		#	└─	simulate the ENTER keypress

		print_result $? "'Homebrew' installation."
	else
		print_success "'Homebrew' is already installed!"
	fi
}

__init__() {
	ask_for_sudo

	print_cat "Now we will install 'Homebrew' the missing package manager for macOS!"
	install_homebrew

	print_cat "Beacuse we don't like analytics about our behaviours!"
	opt_out_of_analaytics

	print_cat "Before we install a lot of cool stuff we have to update 'Homebrew'!"
	brew_update

	print_cat "Homebrew | Upgrade all installed and outdated formulas!"
	brew_upgrade

	print_cat "Homebrew | Tap all necessary additional repositories!"
	brew_tap "homebrew/cask"
	brew_tap "homebrew/cask-drivers"
	brew_tap "homebrew/cask-fonts"

	print_cat "Homebrew | Install some cool 'CLI Tools'!"
	brew_install "mas | Mac App Store command-line interface" "mas"
	brew_install "wget | Internet file retriever" "wget"
	brew_install "tree | Display directories as trees" "tree"
	brew_install "python3 | Interpreted, interactive, object-oriented programming language" "python"
	brew_install "pipenv | Python dependency management tool" "pipenv"
	brew_install "tldr | Simplified and community-driven man pages" "tldr"
	# brew_install "ssllabs-scan | Command-line client for the SSL Labs APIs" "ssllabs-scan"

	print_cat "Homebrew | Install some cool 'Fonts'!"
	brew_install "Awesome Terminal Fonts" "font-awesome-terminal-fonts" "cask"
	brew_install "Fira Code" "font-fira-code" "cask"
	brew_install "Fira Code Nerd Font" "font-fira-code-nerd-font" "cask"
	brew_install "Hack Nerd Font" "font-hack-nerd-font" "cask"
	brew_install "Meslo LG Nerd Font" "font-meslo-lg-nerd-font" "cask"
	brew_install "Monokai Nerd Font" "font-mononoki-nerd-font" "cask"
	brew_install "Montserrat" "font-montserrat" "cask"
	brew_install "Open Sans" "font-open-sans" "cask"
	brew_install "Open Sans Condensed" "font-open-sans-condensed" "cask"
	brew_install "Powerline Symbols" "font-powerline-symbols" "cask"
	brew_install "Profont Nerd Font" "font-profont-nerd-font" "cask"
	brew_install "Roboto" "font-roboto" "cask"
	brew_install "Roboto Mono" "font-roboto-mono" "cask"
	brew_install "Roboto Mono Nerd Font" "font-roboto-mono-nerd-font" "cask"
	brew_install "Roboto Mono for Powerline" "font-roboto-mono-for-powerline" "cask"
	brew_install "Source Code Pro" "font-source-code-pro" "cask"
	brew_install "Source Code Pro for Powerline" "font-source-code-pro-for-powerline" "cask"

	# brew_install "Mozilla Firefox" "firefox" "cask"
}

__init__
