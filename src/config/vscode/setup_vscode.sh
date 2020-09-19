#!/bin/bash
# ================================================================================
# -- File:          vscode/setup_vscode.sh
# -- Project:       auto-mac-setup
# -- Project URL:   https://github.com/moosploit/auto-mac-setup
# -- Create Date:   2020-09-18 14:57
# -- Author:        Michael Linder
# -- Company:       moosploit.com
# -- License:       MIT License | http://www.opensource.org/licenses/MIT
# ================================================================================

# Check whether the script is called directly or via source
if [[ $(basename ${0}) == $(basename ${BASH_SOURCE}) ]]; then
	source ../../../helper/output.sh
	source ../../../helper/utils.sh
	source ../../../helper/global_variables.sh
	VSCODE_DIR="$ROOT_DIR"
else
	VSCODE_DIR="$ROOT_DIR/src/config/vscode"
fi

# === Directory where the VSCode settings files should be stored === /
DOTFILES_VSCODE_DIR="$DOTFILES_DIR/vscode"

install_extensions() {
	ask_for_confirmation "Should I install the extensions now?"
	if ! answer_is_yes; then
		return 1
	fi

	cat $VSCODE_DIR/extensions.txt | while read line; do
		vscode_install_ext "$line"
	done

	kill_app Electron
}

copy_and_link() {
	:
}

setup_config() {

	declare -r MODULE=$(print_highlight "VSCode")
	declare -r DEST_DIR="$DOTFILES_VSCODE_DIR"
	declare -r DEST_DIR_NAME=$(print_highlight "$DEST_DIR/")

	local SETTINGS_FILE=""
	local KEYBINDINGS_FILE=""
	local SNIPPETS_DIR=""

	ask_for_confirmation "Should I setup the configuration now?"
	if ! answer_is_yes; then
		return 1
	fi

	ask_for_confirmation "Should I use the default settings?"
	# == Copy the default files from this folder and symlink them to the origin
	if answer_is_yes; then
		SETTINGS_FILE="$VSCODE_DIR/example/settings.json"
		KEYBINDINGS_FILE="$VSCODE_DIR/example/keybindings.json"
		SNIPPETS_DIR="$VSCODE_DIR/example/snippets"
	# == Copy the original files and symlink them to the origin
	else
		SETTINGS_FILE="$HOME/Library/Application Support/Code/User/settings.json"
		KEYBINDINGS_FILE="$HOME/Library/Application Support/Code/User/keybindings.json"
		SNIPPETS_DIR="$HOME/Library/Application Support/Code/User/snippets"
	fi

	# == Create new folder to store VSCode settings == /
	mkdir -p $HOME/.dotfiles/vscode &>/dev/null

	print_run "$MODULE | Copying $(print_highlight settings.json) to $DEST_DIR_NAME!"
	cp "$SETTINGS_FILE" "$DEST_DIR/settings.json" &>/dev/null
	print_result "$?" "$MODULE | Copyied $(print_highlight settings.json) to $DEST_DIR_NAME!"

	print_run "$MODULE | Create symlink for $(print_highlight settings.json)!"
	ln -sf "$DEST_DIR/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
	print_result "$?" "$MODULE | Symlink $(print_highlight settings.json) created!"

	print_run "$MODULE | Copying $(print_highlight keybindings.json) to $DEST_DIR_NAME!"
	cp "$KEYBINDINGS_FILE" "$DEST_DIR/keybindings.json" &>/dev/null
	print_result "$?" "$MODULE | Copyied $(print_highlight keybindings.json) to $DEST_DIR_NAME!"

	print_run "$MODULE | Create symlink for $(print_highlight keybindings.json)!"
	ln -sf "$DEST_DIR/keybindings.json" "$HOME/Library/Application Support/Code/User/keybindings.json"
	print_result "$?" "$MODULE | Symlink $(print_highlight keybindings.json) created!"

	print_run "$MODULE | Copying folder $(print_highlight snippets/) to $DEST_DIR_NAME!"
	cp -R "$SNIPPETS_DIR" "$DEST_DIR" &>/dev/null
	print_result "$?" "$MODULE | Copyied folder $(print_highlight snippets/) to $DEST_DIR_NAME!"

	print_run "$MODULE | Create symlink for folder $(print_highlight snippets/)!"
	if [[ ! -h "$HOME/Library/Application Support/Code/User/snippets" ]]; then
		rm -r "$HOME/Library/Application Support/Code/User/snippets"
	fi
	ln -sf "$DEST_DIR/snippets" "$HOME/Library/Application Support/Code/User"
	print_result "$?" "$MODULE | Symlink for folder $(print_highlight snippets/) created!"

	kill_app Electron
}

__init__() {

	print_cat "Installation of VSCode extensions!"
	install_extensions

	print_cat "Setting up application VSCode!"
	setup_config
}

__init__
