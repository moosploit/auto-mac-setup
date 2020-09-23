#!/bin/bash
# ================================================================================
# -- File:          ssh/setup_ssh.sh
# -- Project:       auto-mac-setup
# -- Project URL:   https://github.com/moosploit/auto-mac-setup
# -- Create Date:   2020-09-21 18:38
# -- Author:        Michael Linder
# -- Company:       moosploit.com
# -- License:       MIT License | http://www.opensource.org/licenses/MIT
# ================================================================================

# Check whether the script is called directly or via source
if [[ $(basename ${0}) == $(basename ${BASH_SOURCE}) ]]; then
	source ../../../helper/output.sh
	source ../../../helper/utils.sh
	source ../../../helper/global_variables.sh
	SSH_DIR="$ROOT_DIR"
else
	SSH_DIR="$ROOT_DIR/src/config/ssh"
fi

# === Directory where the SSH settings files should be stored === /
DOTFILES_SSH_DIR="$DOTFILES_DIR/ssh"
mkdir -p "$DOTFILES_SSH_DIR" &>/dev/null && chmod 700 "$DOTFILES_SSH_DIR"
DOTFILES_SSH_DIR_NAME=$(print_highlight "$DOTFILES_SSH_DIR")

backup_existing_ssh() {
	declare -r MODULE=$(print_highlight "SSH-Bkp")
	declare -r BACKUP_SSH_DIR="$BACKUP_DIR/ssh"
	declare -r BACKUP_SSH_DIR_NAME=$(print_highlight "$BACKUP_SSH_DIR")

	local HOME_SSH_DIR="$HOME/.ssh"

	ask_for_confirmation "Should I backup the current SSH configuration now?"
	if ! answer_is_yes; then
		return 1
	fi

	if [[ ! -e $HOME_SSH_DIR ]]; then
		print_fail "$MODULE | No SSH backup needed, because SSH configuaration folder doesn't exist!"
		return 2
	fi

	# == If the SSH Folder exists == /
	if [[ -d $HOME_SSH_DIR ]]; then
		print_run "$MODULE | Backing up your SSH configuration to $BACKUP_SSH_DIR_NAME!"
		mkdir -p "$BACKUP_SSH_DIR" &>/dev/null && chmod 700 "$BACKUP_SSH_DIR"
		mv "$HOME_SSH_DIR" "$BACKUP_SSH_DIR" &>/dev/null
		print_result "$?" "$MODULE | Backed up your SSH configuration to $BACKUP_SSH_DIR_NAME!"
	fi
}

create_config_file() {
	declare -r MODULE=$(print_highlight "SSH-Config")

	ask_for_confirmation "Should I create a new basic SSH configuration file?"
	if ! answer_is_yes; then
		return 1
	fi

	print_run "$MODULE | Creating basic SSH configuration file in $DOTFILES_SSH_DIR_NAME!"
	printf "%b\n" \
		"Host *\n  AddKeysToAgent yes\n  UseKeychain yes\n\nInclude ~/.ssh/config.local" >"$DOTFILES_SSH_DIR/config"
	print_result "$?" "$MODULE | Created basic SSH configuration file in $DOTFILES_SSH_DIR_NAME!"
}

create_local_config_file() {
	declare -r MODULE=$(print_highlight "SSH-Config")

	ask_for_confirmation "Should I create a new local SSH configuration file?"
	if ! answer_is_yes; then
		return 1
	fi

	print_run "$MODULE | Creating local SSH configuration file in $DOTFILES_SSH_DIR_NAME!"
	printf "%b\n" \
		"Host example.com\n  HostName example.com\n  Port 22\n  User example-user\n  IdentityFile $HOME/.ssh/id_ed25519_example\n  IdentitiesOnly yes\n" >>"$DOTFILES_SSH_DIR/config.local"
	print_result "$?" "$MODULE | Created local SSH configuration file in $DOTFILES_SSH_DIR_NAME!"
}

generate_ssh_key() {
	declare -r MODULE=$(print_highlight "SSH-KEY")

	local EMAIL=""
	local EMAIL_NAME=""
	local PURPOSE=""
	local SSH_KEY=""
	local SSH_KEY_NAME=""
	local SSH_KEY_PATH="$DOTFILES_SSH_DIR"

	ask_for_confirmation "Should I setup a new SSH Key for you now?"
	if ! answer_is_yes; then
		return 1
	fi

	while [[ -z $EMAIL ]]; do
		ask_for_input "Please provide an EMail address:"
		EMAIL="$REPLY"
		EMAIL_NAME=$(print_highlight "$EMAIL")
	done

	ask_for_input "Please set a purpose for this SSH key or leave it blank:"
	PURPOSE=$REPLY

	if [[ -z $PURPOSE ]]; then
		SSH_KEY="id_ed25519"
	else
		PURPOSE=$(echo $PURPOSE | tr "[:upper:]" "[:lower:]" | tr " " "-")
		SSH_KEY="id_ed25519_$PURPOSE"
	fi
	SSH_KEY_NAME=$(print_highlight "$SSH_KEY")

	print_run "$MODULE | Generating SSH-Key $SSH_KEY_NAME for EMail $EMAIL_NAME!"
	ssh-keygen -o -t ed25519 -a 256 -C "$EMAIL" -f "$SSH_KEY_PATH/$SSH_KEY"
	print_result "$?" "$MODULE | SSH-Key $SSH_KEY_NAME generated and stored at $SSH_KEY_PATH!"

	print_run "$MODULE | Adding SSH-Key $SSH_KEY_NAME to your keychain for easier use!"
	ssh-add -K "$SSH_KEY_PATH/$SSH_KEY"
	print_result "$?" "$MODULE | SSH-Key $SSH_KEY_NAME added to keychain!"
}

__init__() {
	print_cat "Backup SSH configuration first!"
	backup_existing_ssh

	print_cat "Create basic SSH configuration file!"
	create_config_file

	print_cat "Create local SSH configuration file!"
	create_local_config_file

	print_cat "Creating type ED25519 SSH Key!"
	generate_ssh_key

	create_symlink "SSH" "SSH Configuration" "$DOTFILES_SSH_DIR" "$HOME/.ssh"
}

__init__
