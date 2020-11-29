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
if [[ $(basename ${0}) == $(basename ${BASH_SOURCE}) ]]; then
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

	print_cat "Before we install a lot of cool stuff we have to update 'Homebrew' first!"
	brew_update

	print_cat "Homebrew | Upgrade all installed and outdated formulas!"
	brew_upgrade

	print_cat "Homebrew | Tap all necessary additional repositories!"
	brew_tap "homebrew/cask"
	brew_tap "homebrew/cask-drivers"
	brew_tap "homebrew/cask-fonts"

	print_cat "Homebrew | Install some cool 'CLI Tools'!"
	brew_install "Mas" "mas"
	brew_install "Glances" "glances"
	brew_install "Wget" "wget"
	brew_install "Tree" "tree"
	brew_install "Python3" "python"
	brew_install "Pipenv" "pipenv"
	brew_install "Tldr" "tldr"
	brew_install "GitHub CLI" "gh"
	# brew_install "Zsh-autosuggestions" "zsh-autosuggestions"
	# brew_install "Zsh-syntax-highlighting" "zsh-syntax-highlighting"
	# brew_install "ssllabs-scan | Command-line client for the SSL Labs APIs" "ssllabs-scan"

	print_cat "Homebrew | Install some cool 'Fonts'!"
	brew_install "Awesome Terminal Fonts" "font-awesome-terminal-fonts" "cask"
	brew_install "Barlow" "font-barlow" "cask"
	brew_install "Barlow Condensed" "font-barlow-condensed" "cask"
	brew_install "Barlow Semi Condensed" "font-barlow-semi-condensed" "cask"
	brew_install "Cascadia Code" "font-cascadia-code" "cask"
	brew_install "Fira Code" "font-fira-code" "cask"
	brew_install "Fira Code Nerd Font" "font-fira-code-nerd-font" "cask"
	brew_install "Hack Nerd Font" "font-hack-nerd-font" "cask"
	brew_install "JetBrains Mono" "font-jetbrains-mono" "cask"
	brew_install "Merienda One" "font-merienda-one" "cask"
	brew_install "Meslo For Powerline" "font-meslo-for-powerline" "cask"
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
	brew_install "Roboto Mono For Powerline" "font-roboto-mono-for-powerline" "cask"
	brew_install "Source Code Pro" "font-source-code-pro" "cask"
	brew_install "Source Code Pro for Powerline" "font-source-code-pro-for-powerline" "cask"

	print_cat "Homebrew | Install some usefull 'Tools'!"
	brew_install "Keka" "keka" "cask"
	brew_install "ForkLift" "forklift" "cask"
	brew_install "Alfred" "alfred" "cask"
	brew_install "AppCleaner" "appcleaner" "cask"
	brew_install "CheatSheet" "cheatsheet" "cask"
	brew_install "iStat Menus" "istat-menus" "cask"
	brew_install "BetterTouchTool" "bettertouchtool" "cask"
	brew_install "Logitech Options" "logitech-options" "cask"
	brew_install "Monitor Control" "monitorcontrol" "cask"
	brew_install "Steelseries Excatmouse Tool" "steelseries-exactmouse-tool" "cask"

	print_cat "Homebrew | Install some cool 'Multimedia' applications!"
	brew_install "VLC Media Player" "vlc" "cask"
	brew_install "Plex Client" "plex" "cask"
	brew_install "Spotify" "spotify" "cask"
	brew_install "Handbrake" "handbrake" "cask"

	print_cat "Homebrew | Install some nifty 'Media Editing' applications!"
	brew_install "Adobe Creative Cloud" "adobe-creative-cloud" "cask"

	print_cat "Homebrew | Install some dusty 'Office' applications!"
	brew_install "1Password" "1password" "cask"
	brew_install "TeamViewer" "teamviewer" "cask"
	brew_install "jDownloader" "jdownloader" "cask"
	brew_install "MacTeX No Gui" "mactex-no-gui" "cask"

	print_cat "Homebrew | Install some cool 'Development' applications!"
	brew_install "iTerm2 Terminal Emulator" "iterm2" "cask"
	brew_install "Visual Studio Code" "visual-studio-code" "cask"
	brew_install "Atom" "atom" "cask"
	brew_install "GitHub Client" "github" "cask"
	brew_install "CodeKit" "codekit" "cask"
	brew_install "Insomnia" "insomnia" "cask"
	brew_install "Sequel Pro" "sequel-pro" "cask"

	print_cat "Homebrew | Install some 'Virtualization' applications!"
	brew_install "VMware Fusion" "vmware-fusion" "cask"
	brew_install "Oracle VirtualBox" "virtualbox" "cask"

	print_cat "Homebrew | Install some cool 'SocialMedia - Messanger - Blogging' applications!"
	brew_install "Flume" "flume" "cask"
	brew_install "Signal" "signal" "cask"
	brew_install "WhatsApp" "whatsapp" "cask"
	# brew_install "Telegram" "telegram" "cask"
	brew_install "Discord" "discord" "cask"
	brew_install "Wordpress Client" "wordpresscom" "cask"

	print_cat "Homebrew | Install some necessary 'Browser' applications!"
	brew_install "Firefox" "firefox" "cask"
	brew_install "Google Chrome" "google-chrome" "cask"
	brew_install "Tor Browser" "tor-browser" "cask"

	print_cat "Homebrew | Install some 'Cloud Storage' applications!"
	brew_install "NextCloud" "nextcloud" "cask"

	print_cat "Homebrew | Install some 'Security' applications!"
	brew_install "Little Snitch" "little-snitch" "cask"
}

__init__
