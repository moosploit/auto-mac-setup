#!/bin/bash
# ================================================================================
# -- File:          helper/utils.sh
# -- Project:       auto-mac-setup
# -- Project URL:   https://github.com/moosploit/auto-mac-setup
# -- Create Date:   2020-09-01 15:45
# -- Author:        Michael Linder
# -- Company:       moosploit.com
# -- License:       MIT License | http://www.opensource.org/licenses/MIT
# ================================================================================

# Check whether the script is called directly or via source
$(return &>/dev/null)

if [ "$?" -ne "0" ]; then
	source ./output.sh
fi

# === Handling Questions Functions === /
check_cmd_exists() {
	command -v "$1" &>/dev/null
}

check_already_sudo() {
	sudo -n true 2>/dev/null
}

# === Handling Questions === /
ask_for_sudo() {
	if ! check_already_sudo; then
		print_cat "May i have your password please?"

		sudo -v

		# https://gist.github.com/cowboy/3118588
		while true; do
			sudo -n true
			sleep 60
			kill -0 "$$" || exit
		done &>/dev/null &
	else
		print_cat "You have already sudo privileges!"
	fi
}

ask_for_confirmation() {
	print_question "$1 (y|N) "
	read -r -p "          "
}

answer_is_yes() {
	[[ "$REPLY" =~ (y|Y) ]] && return 0 || return 1
}

# === Operating System Functions === /
get_os() {
	local os=""
	local kernelName="$(uname -s)"

	if [ "$kernelName" == "Darwin" ]; then
		os="macos"
	elif [ "$kernelName" == "Linux" ] && [ -e "/etc/os-release" ]; then
		os="$(
			. /etc/os-release
			printf "%s" "$ID"
		)"
	else
		os="$kernelName"
	fi

	printf "%s" "$os"
}

get_os_version() {
	local version=""
	local os="$(get_os)"

	if [ "$os" == "macos" ]; then
		version="$(sw_vers -productVersion)"
	elif [ -e "/etc/os-release" ]; then
		version="$(
			. /etc/os-release
			printf "%s" "$VERSION_ID"
		)"
	fi

	printf "%s" "$version"
}

# === Homebrew Wrapper Functions === /
brew_install() {
	# brew_install "Google Chrome" "google-chrome" "cask"
	declare -r FORMULA_NAME="$1" # Google Chrome
	declare -r FORMULA="$2"      # google-chrome
	declare -r CMD="$3"          # cask

	if [[ "$#" -lt 2 ]]; then
		print_fail "There are not enough arguments specified for 'brew_install'! "
		return 1
	fi

	if [[ -z "$CMD" ]]; then # == [[ $CMD not set ]] == /
		brew list $FORMULA &>/dev/null
		if [[ "$?" -eq 0 ]]; then
			print_success "$FORMULA_NAME is already installed!"
			return 2
		fi
		print_run "Installing '$FORMULA_NAME'!"
		brew install $FORMULA &>/dev/null
		print_result "$?" "Installation of '$FORMULA_NAME'"
	else # == [[ $CMD is set ]] == /
		case "$CMD" in
		cask)
			brew list --cask "$FORMULA" &>/dev/null
			if [[ "$?" -eq 0 ]]; then
				print_success "'$FORMULA_NAME' is already installed!"
				return 2
			fi
			brew cask install $FORMULA &>/dev/null
			print_result "$?" "Installation of '$FORMULA_NAME'"
			;;
		*)
			print_fail "Installation of '$FORMULA_NAME' failed, because command '$CMD' not defined!"
			;;
		esac
	fi
}

brew_update() {
	print_run "Updating 'Homebrew'!"

	brew update &>/dev/null
	print_result "$?" "'Homebrew' update."
}

brew_upgrade() {
	print_run "Upgrading all installed and outdated 'Homebrew' formulas!"

	brew upgrade &>/dev/null
	print_result "$?" "Upgrade of installed and outdated 'Homebrew' formulas!"
}

brew_tap() {
	if ! brew tap | grep "$1" -i &>/dev/null; then
		print_run "'Homebrew' is tapping '$1'!"
		brew tap "$1" &>/dev/null
		print_result "$?" "Tapping of $1"
	else
		print_success "'$1' is already tapped into 'Homebrew'"
	fi

}

# === MacAppStore (MAS) Wrapper Functions === /
mas_install() {
	:
}
mas_update() {
	:
}
