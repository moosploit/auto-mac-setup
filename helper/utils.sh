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
if [[ $(basename ${0}) == $(basename ${BASH_SOURCE}) ]]; then
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

ask_for_input() {
	print_question "$1"
	read -r -p "          "
}

ask_for_confirmation() {
	print_question "$1 (y|N) "
	read -r -p "          "
}

answer_is_yes() {
	[[ "$REPLY" =~ ^([yY][eE][sS]|[yY])$ ]] && return 0 || return 1
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

kill_app() {
	declare -r APPS="$@"

	for app in $APPS; do
		app_name=$(print_highlight $app)

		print_run "Killing the application $app_name!"
		killall "$app" &>/dev/null
		print_result "$?" "Application $app_name killed!"
	done
	sleep 2
}

# === User Details Functions === /
get_username() {
	echo $(id -un) # whomai
}

get_full_username() {
	osascript -e "long user name of (system info)"
}

# === Homebrew Wrapper Functions === /
brew_install() {
	# brew_install "Google Chrome" "google-chrome" "cask"
	declare -r FORMULA_NAME=$(print_highlight "$1") # Google Chrome
	declare -r FORMULA="$2"                         # google-chrome
	declare -r CMD="$3"                             # cask
	declare -r MODULE=$(print_highlight "Brew-Install")

	if [[ "$#" -lt 2 ]]; then
		print_fail "There are not enough arguments specified for 'brew_install'! "
		return 1
	fi

	# == [[ $CMD not set ]] == /
	if [[ -z "$CMD" ]]; then
		# == Check if brew formula already installed == /
		brew list "$FORMULA" &>/dev/null
		if [[ "$?" -eq 0 ]]; then
			print_success "$MODULE | Formula $FORMULA_NAME is already installed!"
			return 2
		fi

		# == Install brew formula == /
		print_run "$MODULE | Installing formula $FORMULA_NAME!"
		brew install "$FORMULA" &>/dev/null
		print_result "$?" "$MODULE | Installation of formula $FORMULA_NAME"
	# == [[ $CMD is set ]] == /
	else
		case "$CMD" in
		cask)
			# == Check if brew cask formula already installed == /
			brew list --cask "$FORMULA" &>/dev/null
			if [[ "$?" -eq 0 ]]; then
				print_success "$MODULE | Cask Formula $FORMULA_NAME is already installed!"
				return 2
			fi
			# == Install brew cask formula == /
			print_run "$MODULE | Installing cask formula $FORMULA_NAME!"
			brew cask install "$FORMULA" &>/dev/null
			print_result "$?" "$MODULE | Installation of cask formula $FORMULA_NAME"
			;;
		*)
			print_fail "$MODULE | Installation of formula $FORMULA_NAME failed, because command '$CMD' is not defined!"
			return 99
			;;
		esac
	fi
}

brew_update() {
	declare -r MODULE=$(print_highlight "Brew-Update")
	print_run "$MODULE | Updating formulas!"

	brew update &>/dev/null
	print_result "$?" "$MODULE | Formulas update."
}

brew_upgrade() {
	declare -r MODULE=$(print_highlight "Brew-Upgrade")
	print_run "$MODULE | Upgrading all installed and outdated formulas!"

	brew upgrade &>/dev/null
	print_result "$?" "$MODULE | Upgrade of installed and outdated formulas!"
}

brew_tap() {
	declare -r REPO=$(print_highlight "$1")
	declare -r MODULE=$(print_highlight "Brew-Tap")

	if ! brew tap | grep "$1" -i &>/dev/null; then
		print_run "$MODULE | is tapping repository $REPO!"
		brew tap "$1" &>/dev/null
		print_result "$?" "$MODULE | Tapping of repository $REPO"
	else
		print_success "$MODULE | the repository $REPO is already tapped."
	fi

}

# === MacAppStore (MAS) Wrapper Functions === /
mas_install() {
	# mas_install "Numbers" "409203825"
	declare -r APP_NAME=$(print_highlight "$1") # Numbers
	declare -r APP_ID="$2"                      # 409203825
	declare -r MODULE=$(print_highlight "MAS-Install")

	# == Check if enough arguments specified == /
	if [[ "$#" -lt 2 ]]; then
		print_fail "There are not enough arguments specified for 'mas_install'! "
		return 1
	fi

	# == Check if MAS App already installed == /
	mas list | grep "$APP_ID" | head -n 1 &>/dev/null
	if [[ "$?" -eq 0 ]]; then
		print_success "$MODULE | Application $APP_NAME is already installed!"
		return 2
	fi

	# == Install MAS App == /
	print_run "$MODULE | Installing application $APP_NAME!"
	mas install "$APP_ID" &>/dev/null
	print_result "$?" "$MODULE | Installation of application $APP_NAME"
}

mas_update() {
	declare -r MODULE=$(print_highlight "MAS-Update")
}

# === macOS Defaults Wrapper Functions === /
defaults_write() {
	declare -r DOMAIN_NAME=$(print_highlight "$1")
	declare -r DOMAIN="$2"
	declare -r KEY="$3"
	declare -r KEY_NAME=$(print_highlight "$KEY")
	declare -r TYPE="$4"

	local VALUE="$5"
	local VALUE_NAME=$(print_highlight "$VALUE")

	# == Check if enough arguments specified == /
	if [[ "$#" -lt 5 ]]; then
		print_fail "There are not enough arguments specified for 'defaults_write'! "
		return 1
	fi

	case "$TYPE" in
	# == If type is string, int, integer or float == /
	string | int | integer | float)
		# == Checks whether the key exists or the sent value is already set
		if [[ $(defaults read "$DOMAIN" "$KEY" 2>/dev/null) == "$VALUE" ]]; then
			print_success "$DOMAIN_NAME | The setting $KEY_NAME is already set to $VALUE_NAME!"
			return 2
		fi
		;;
	# == If type is bool or boolean == /
	bool | boolean)
		case "$VALUE" in
		# == If value is true or 1 == /
		true | 1)
			VALUE="true"
			VALUE_NAME=$(print_highlight "$VALUE")
			# == Checks whether the key exists or the sent value is already set
			if [[ $(defaults read "$DOMAIN" "$KEY" 2>/dev/null) == "1" ]]; then
				print_success "$DOMAIN_NAME | The setting $KEY_NAME is already set to $VALUE_NAME!"
				return 2
			fi
			;;
		# == If value is false or 0 == /
		false | 0)
			VALUE="false"
			VALUE_NAME=$(print_highlight "$VALUE")
			# == Checks whether the key exists or the sent value is already set
			if [[ $(defaults read "$DOMAIN" "$KEY" 2>/dev/null) == "0" ]]; then
				print_success "$DOMAIN_NAME | The setting $KEY_NAME is already set to $VALUE_NAME!"
				return 2
			fi
			;;
		esac
		;;
	# == If another type was sent
	*)
		print_error "Defaults | Type '$TYPE' is in function 'defaults_write' not allowed!"
		return 99
		;;
	esac

	print_run "$DOMAIN_NAME | Will set $KEY_NAME to $VALUE_NAME!"
	defaults write "$DOMAIN" "$KEY" "-$TYPE" "$VALUE"
	print_result "$?" "$DOMAIN_NAME | Set up $KEY_NAME to $VALUE_NAME!"
}

add_app_to_dock() {
	declare -r DOCK_SIDE="$1"
	declare -r DOCK_SIDE_NAME=$(print_highlight "$DOCK_SIDE")
	declare -r APP="$2"
	declare -r APP_NAME=$(print_highlight "$APP")
	declare -r SYSTEM="$3"
	declare -r MODULE=$(print_highlight "Apple Dock")

	local KEY=""
	local APP_ARRAY=""

	# == Check if enough arguments specified == /
	if [[ "$#" -lt 2 ]]; then
		print_fail "There are not enough arguments specified for 'add_app_to_dock'! "
		return 1
	fi

	# == On which side of the Dock should the application be placed
	case $DOCK_SIDE in
	left)
		KEY="persistent-apps"
		;;
	right)
		KEY="persistent-others"
		;;
	esac

	# == If the application is a spacer
	if [[ "$APP" =~ ^[sS](pacer|eperator) ]]; then
		APP_ARRAY="<dict><key>tile-data</key><dict></dict><key>tile-type</key><string>spacer-tile</string></dict>"
	# == If the application is not a spacer
	else
		# == If the application is a apple default application
		if [[ -n "$SYSTEM" ]]; then
			APP_ARRAY="<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>System/Applications/$APP.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
		# == If the application is a normal application
		else
			APP_ARRAY="<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/$APP.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
		fi
	fi

	print_run "$MODULE | Adding application $APP_NAME to the $DOCK_SIDE_NAME!"
	defaults write com.apple.dock "$KEY" -array-add "$APP_ARRAY"
	print_result "$?" "$MODULE | Added application $APP_NAME to the $DOCK_SIDE_NAME!"
	sleep 1
}

wipe_apps_from_dock() {
	declare -r DOCK_SIDE="$1"
	declare -r DOCK_SIDE_NAME=$(print_highlight "$DOCK_SIDE")
	declare -r MODULE=$(print_highlight "Apple Dock")

	local KEY=""

	# == On which side of the Dock should the application be wiped
	case $DOCK_SIDE in
	left)
		KEY="persistent-apps"
		;;
	right)
		KEY="persistent-others"
		;;
	esac

	print_run "$MODULE | Wiping all applications from the $DOCK_SIDE_NAME!"
	defaults write com.apple.dock "$KEY" -array
	print_result "$?" "$MODULE | Wiped all applications from the $DOCK_SIDE_NAME!"
	sleep 1
}

# === macOS Scutil Wrapper Functions === /
scutil_get() {
	declare -r PREF=$1

	# == Check if enough arguments specified == /
	if [[ "$#" -lt 1 ]]; then
		print_fail "There are not enough arguments specified for 'scutil_get'! "
		return 1
	fi

	sudo scutil --get $PREF 2>/dev/null
}

scutil_set() {
	declare -r PREF=$1
	declare -r PREF_NAME=$(print_highlight "$PREF")
	declare -r VALUE=$2
	declare -r VALUE_NAME=$(print_highlight "$VALUE")
	declare -r MODULE=$(print_highlight "Scutil-Set")

	# == Check if enough arguments specified == /
	if [[ "$#" -lt 2 ]]; then
		print_fail "There are not enough arguments specified for 'scutil_set'! "
		return 1
	fi

	if [[ $(scutil_get "$PREF") == "$VALUE" ]]; then
		print_success "$MODULE | Setting $PREF_NAME is already set to $VALUE_NAME!"
		return 2
	fi

	print_run "$MODULE | Setting $PREF_NAME to $VALUE_NAME!"
	sudo scutil --set $PREF $VALUE &>/dev/null
	print_result "$?" "$MODULE | Set $PREF_NAME to $VALUE_NAME!"
}

# === macOS PlistBuddy Wrapper Functions === /
plist_get() {
	declare -r PROPERTY="$1" # == : seperated path to property
	declare -r PLIST="$2"    # == Absolut path to PLIST file

	# == Check if enough arguments specified == /
	if [[ "$#" -lt 2 ]]; then
		print_fail "There are not enough arguments specified for 'plist_get'! "
		return 1
	fi

	/usr/libexec/PlistBuddy -c "Print :$PROPERTY" "$PLIST" #2>/dev/null
}

plist_set() {
	declare -r MODULE=$(print_highlight "$1")               # == Module name which the plist file belongs to
	declare -r PROPERTY=$2                                  # == Path to property seperated by :
	declare -r PROPERTY_NAME=$(print_highlight "$PROPERTY") # == Color formated property
	declare -r VALUE=$3                                     # == New value for the property
	declare -r VALUE_NAME=$(print_highlight "$VALUE")       # == Color formated value
	declare -r PLIST=$4                                     # == Absolut path to PLIST file

	# == Check if enough arguments specified == /
	if [[ "$#" -lt 4 ]]; then
		print_fail "There are not enough arguments specified for 'plist_set'! "
		return 1
	fi

	if [[ $(plist_get "$PROPERTY" "$PLIST") == "$VALUE" ]]; then
		print_success "$MODULE | Setting $PROPERTY_NAME is already set to $VALUE_NAME!"
		return 2
	fi

	print_run "$MODULE | Setting $PROPERTY_NAME to $VALUE_NAME!"
	/usr/libexec/PlistBuddy -c "Set :$PROPERTY $VALUE" "$PLIST"
	print_result "$?" "$MODULE | Set $PROPERTY_NAME to $VALUE_NAME!"

}
