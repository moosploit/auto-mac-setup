#!/bin/bash
# ============================================================================
# -- File:          ssh/setup_ssh.sh
# -- Project:       auto-mac-setup
# -- Project URL:   https://github.com/moosploit/auto-mac-setup
# -- Create Date:   2020-09-21 18:38
# -- Author:        moosploit
# -- License:       MIT License | http://www.opensource.org/licenses/MIT
# ============================================================================

# Check whether the script is called directly or via source
if [[ $(basename ${0}) == $(basename ${BASH_SOURCE}) ]]; then
    source ../../../helper/output.sh
    source ../../../helper/utils.sh
    source ../../../helper/global_variables.sh
    project_dir_ssh="$ROOT_DIR"
else
    project_dir_ssh="$ROOT_DIR/src/setup/ssh"
fi

# === Directory where the SSH settings files should be stored === /
dotfiles_dir_ssh="$DOTFILES_DIR/ssh"
mkdir -p "$dotfiles_dir_ssh" &>/dev/null && chmod 700 "$dotfiles_dir_ssh"
dotfiles_dir_ssh_highlight=$(print_highlight "$dotfiles_dir_ssh")

backup_existing_ssh() {
    declare -r module_name_highlight=$(print_highlight "SSH-Bkp")
    declare -r backup_dir_ssh="$BACKUP_DIR/ssh"
    declare -r backup_dir_ssh_highlight=$(print_highlight "$backup_dir_ssh")

    local HOME_SSH_DIR="$HOME/.ssh"

    ask_for_confirmation "Should I backup the current SSH configuration now?"
    if ! answer_is_yes; then
        return 1
    fi

    if [[ ! -e $HOME_SSH_DIR ]]; then
        print_fail "$module_name_highlight | No SSH backup needed, because SSH configuaration folder doesn't exist!"
        return 2
    fi

    # == If the SSH Folder exists == /
    if [[ -d $HOME_SSH_DIR ]]; then
        print_run "$module_name_highlight | Backing up your SSH configuration to $backup_dir_ssh_highlight!"
        mkdir -p "$backup_dir_ssh" &>/dev/null && chmod 700 "$backup_dir_ssh"
        mv "$HOME_SSH_DIR" "$backup_dir_ssh" &>/dev/null
        print_result "$?" "$module_name_highlight | Backed up your SSH configuration to $backup_dir_ssh_highlight!"
    fi
}

create_config_file() {
    declare -r module_name_highlight=$(print_highlight "SSH-Config")

    ask_for_confirmation "Should I create a new basic SSH configuration file?"
    if ! answer_is_yes; then
        return 1
    fi

    print_run "$module_name_highlight | Creating basic SSH configuration file in $dotfiles_dir_ssh_highlight!"
    printf "%b\n" \
        "Host *\n  AddKeysToAgent yes\n  UseKeychain yes\n\nInclude ~/.ssh/config.local" >"$dotfiles_dir_ssh/config"
    print_result "$?" "$module_name_highlight | Created basic SSH configuration file in $dotfiles_dir_ssh_highlight!"
}

create_local_config_file() {
    declare -r module_name_highlight=$(print_highlight "SSH-Config")

    ask_for_confirmation "Should I create a new local SSH configuration file?"
    if ! answer_is_yes; then
        return 1
    fi

    print_run "$module_name_highlight | Creating local SSH configuration file in $dotfiles_dir_ssh_highlight!"
    printf "%b\n" \
        "Host example.com\n  HostName example.com\n  Port 22\n  User example-user\n  IdentityFile $HOME/.ssh/id_ed25519_example\n  IdentitiesOnly yes\n" >>"$dotfiles_dir_ssh/config.local"
    print_result "$?" "$module_name_highlight | Created local SSH configuration file in $dotfiles_dir_ssh_highlight!"
}

generate_ssh_key() {
    declare -r module_name_highlight=$(print_highlight "SSH-KEY")

    local email=""
    local email_highlight=""
    local purpose=""
    local ssh_key=""
    local ssh_key_highlight=""
    local ssh_key_path="$dotfiles_dir_ssh"

    ask_for_confirmation "Should I setup a new SSH Key for you now?"
    if ! answer_is_yes; then
        return 1
    fi

    while [[ -z $email ]]; do
        ask_for_input "Please enter an validt EMail address:"
        email="$REPLY"
        email_highlight=$(print_highlight "$email")
    done

    ask_for_input "Please set a purpose for this SSH key or leave it blank:"
    purpose=$REPLY

    if [[ -z $purpose ]]; then
        ssh_key="id_ed25519"
    else
        purpose=$(echo $purpose | tr "[:upper:]" "[:lower:]" | tr " " "-")
        ssh_key="id_ed25519_$purpose"
    fi
    ssh_key_highlight=$(print_highlight "$ssh_key")

    print_run "$module_name_highlight | Generating SSH-Key $ssh_key_highlight for EMail $email_highlight!"
    ssh-keygen -o -t ed25519 -a 256 -C "$email" -f "$ssh_key_path/$ssh_key"
    print_result "$?" "$module_name_highlight | SSH-Key $ssh_key_highlight generated and stored at $ssh_key_path!"

    print_run "$module_name_highlight | Adding SSH-Key $ssh_key_highlight to your keychain for easier use!"
    ssh-add -K "$ssh_key_path/$ssh_key"
    print_result "$?" "$module_name_highlight | SSH-Key $ssh_key_highlight added to keychain!"
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

    create_symlink "SSH" "SSH Configuration" "$dotfiles_dir_ssh" "$HOME/.ssh"
}

__init__
