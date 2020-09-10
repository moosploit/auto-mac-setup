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

# === Check Functions === /
check_cmd_exists() {
	command -v "$1" &>/dev/null
}

check_already_sudo() {
	sudo -n true 2>/dev/null
}

# === Question Handling Functions === /
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

# === User Details Functions === /
get_full_username() {
	osascript -e "long user name of (system info)"
}

# === Homebrew Wrapper Functions === /
brew_install() {
	# brew_install "Google Chrome" "google-chrome" "cask"
	declare -r FORMULA_NAME=$(print_in_cyan "$1") # Google Chrome
	declare -r FORMULA="$2"                       # google-chrome
	declare -r CMD="$3"                           # cask

	if [[ "$#" -lt 2 ]]; then
		print_fail "There are not enough arguments specified for 'brew_install'! "
		return 1
	fi

	# == [[ $CMD not set ]] == /
	if [[ -z "$CMD" ]]; then
		# == Check if brew formula already installed == /
		brew list "$FORMULA" &>/dev/null
		if [[ "$?" -eq 0 ]]; then
			print_success "Homebrew | Formula $FORMULA_NAME is already installed!"
			return 2
		fi

		# == Install brew formula == /
		print_run "Homebrew | Installing formula $FORMULA_NAME!"
		brew install "$FORMULA" &>/dev/null
		print_result "$?" "Homebrew | Installation of formula $FORMULA_NAME"
	# == [[ $CMD is set ]] == /
	else
		case "$CMD" in
		cask)
			# == Check if brew cask formula already installed == /
			brew list --cask "$FORMULA" &>/dev/null
			if [[ "$?" -eq 0 ]]; then
				print_success "Homebrew | Cask Formula $FORMULA_NAME is already installed!"
				return 2
			fi
			# == Install brew cask formula == /
			print_run "Homebrew | Installing cask formula $FORMULA_NAME!"
			brew cask install "$FORMULA" &>/dev/null
			print_result "$?" "Homebrew | Installation of cask formula $FORMULA_NAME"
			;;
		*)
			print_fail "Homebrew | Installation of formula $FORMULA_NAME failed, because command '$CMD' is not defined!"
			return 99
			;;
		esac
	fi
}

brew_update() {
	print_run "Homebrew | Updating formulas!"

	brew update &>/dev/null
	print_result "$?" "Homebrew | Formulas update."
}

brew_upgrade() {
	print_run "Homebrew | Upgrading all installed and outdated formulas!"

	brew upgrade &>/dev/null
	print_result "$?" "Homebrew | Upgrade of installed and outdated formulas!"
}

brew_tap() {
	declare -r REPO=$(print_in_cyan "$1")

	if ! brew tap | grep "$1" -i &>/dev/null; then
		print_run "Homebrew | is tapping repository $REPO!"
		brew tap "$1" &>/dev/null
		print_result "$?" "Homebrew | Tapping of repository $REPO"
	else
		print_success "Homebrew | the repository $REPO is already tapped."
	fi

}

# === MacAppStore (MAS) Wrapper Functions === /
mas_install() {
	# mas_install "Numbers" "409203825"
	declare -r APP_NAME=$(print_in_cyan "$1") # Numbers
	declare -r APP_ID="$2"                    # 409203825

	# == Check if enough arguments specifies == /
	if [[ "$#" -lt 2 ]]; then
		print_fail "There are not enough arguments specified for 'mas_install'! "
		return 1
	fi

	# == Check if MAS App already installed == /
	mas list | grep "$APP_ID" | head -n 1 &>/dev/null
	if [[ "$?" -eq 0 ]]; then
		print_success "MAS | Application $APP_NAME is already installed!"
		return 2
	fi

	# == Install MAS App == /
	print_run "MAS | Installing application $APP_NAME!"
	mas install "$APP_ID" &>/dev/null
	print_result "$?" "MAS | Installation of application $APP_NAME"
}

mas_update() {
	:
}
