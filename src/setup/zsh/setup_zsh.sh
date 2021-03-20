#!/bin/bash
# ============================================================================
# -- File:          zsh/setup_zsh.sh
# -- Project:       auto-mac-setup
# -- Project URL:   https://github.com/moosploit/auto-mac-setup
# -- Create Date:   2020-09-25 11:18
# -- Author:        moosploit
# -- License:       MIT License | http://www.opensource.org/licenses/MIT
# ============================================================================

# Check whether the script is called directly or via source
if [[ $(basename ${0}) == $(basename ${BASH_SOURCE}) ]]; then
    source ../../../helper/output.sh
    source ../../../helper/utils.sh
    source ../../../helper/global_variables.sh
    project_dir_zsh="$ROOT_DIR"
else
    project_dir_zsh="$ROOT_DIR/src/setup/zsh"
fi

# === Directory where the ZSH settings files should be stored === /
dotfiles_dir_zsh="$DOTFILES_DIR/zsh"
dotfiles_dir_zsh_highlight=$(print_highlight "$dotfiles_dir_zsh")
# == Create new folder to store ZSH settings == /
mkdir -p "$dotfiles_dir_zsh" &>/dev/null && chmod 700 "$dotfiles_dir_zsh"

backup_existing_zsh() {
    declare -r module_name_highlight=$(print_highlight "ZSH-Bkp")
    declare -r backup_dir_zsh="$BACKUP_DIR/zsh"
    declare -r backup_dir_zsh_highlight=$(print_highlight "$backup_dir_zsh")

    local zsh_config_files=(".zshenv" ".zprofile" ".zshrc" ".zlogin" ".zlogout" ".zsh_history")

    ask_for_confirmation "Should I backup the current ZSH configuration files now?"
    if ! answer_is_yes; then
        return 1
    fi

    for zsh_config_file in "${zsh_config_files[@]}"; do
        local file_name=$(print_highlight "$zsh_config_file")

        # == If the zsh zsh_config_file not exists == /
        if [[ ! -e "$HOME/$zsh_config_file" ]]; then
            print_fail "$module_name_highlight | File $file_name not found, will not be backed up!"
        # == If the zsh zsh_config_file exist == /
        else
            print_run "$module_name_highlight | Backing up ZSH config zsh_config_file $file_name to $backup_dir_zsh_highlight!"
            mkdir -p "$backup_dir_zsh" &>/dev/null && chmod 700 "$backup_dir_zsh"
            mv "$HOME/$zsh_config_file" "$backup_dir_zsh" &>/dev/null
            print_result "$?" "$module_name_highlight | Backed up your ZSH config zsh_config_file $file_name to $backup_dir_zsh_highlight!"
        fi
    done
}

install_oh_my_zsh() {
    declare -r module_name_highlight=$(print_highlight "OMZ")

    ask_for_confirmation "Should I install oh-my-zsh now?"
    if ! answer_is_yes; then
        return 1
    fi

    print_run "$module_name_highlight | Installing zsh framework $(print_highlight "oh-my-zsh")!"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    print_result "$?" "$module_name_highlight | Installation of zsh framework $(print_highlight "oh-my-zsh")!"
}

install_oh_my_zsh_plugins() {
    declare -r module_name_highlight=$(print_highlight "OMZ-Plugins")

    ask_for_confirmation "Should I install oh-my-zsh plugins now?"
    if ! answer_is_yes; then
        return 1
    fi

    print_run "$module_name_highlight | Installing oh-my-zsh plugin $(print_highlight "zsh-autosuggestions") now!"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions &>/dev/null
    print_result "$?" "$module_name_highlight | Installation of oh-my-zsh plugin $(print_highlight "zsh-autosuggestions")!"

    print_run "$module_name_highlight | Installing oh-my-zsh plugin $(print_highlight "zsh-syntax-highlighting") now!"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting &>/dev/null
    print_result "$?" "$module_name_highlight | Installation of oh-my-zsh plugin $(print_highlight "zsh-syntax-highlighting")!"
}

install_oh_my_zsh_theme_p10k() {
    declare -r module_name_highlight=$(print_highlight "OMZ-Theme")

    ask_for_confirmation "Should I install the oh-my-zsh theme Powerlevel10k now?"
    if ! answer_is_yes; then
        return 1
    fi

    print_run "$module_name_highlight | Installing oh-my-zsh theme $(print_highlight "Powerlevel10k") now!"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k &>/dev/null
    print_result "$?" "$module_name_highlight | Installation of oh-my-zsh theme $(print_highlight "Powerlevel10k")!"

    # Remove unnecessary default config zsh_config_file for p10k
    [[ -e ~/.p10k.zsh ]] && rm ~/.p10k.zsh
}

configure_zsh() {
    declare -r module_name_highlight=$(print_highlight "ZSH")

    local zsh_config_files=("zshenv" "zshrc" "p10k.zsh" "aliases" "functions")

    ask_for_confirmation "Should I configure your ZSH now?"
    if ! answer_is_yes; then
        return 1
    fi

    for zsh_config_file in "${zsh_config_files[@]}"; do
        local zsh_config_file_highlight=$(print_highlight "$zsh_config_file")

        print_run "$module_name_highlight | Copy ZSH config file $zsh_config_file_highlight in $dotfiles_dir_zsh_highlight!"
        cp "$project_dir_zsh/example/$zsh_config_file" "$dotfiles_dir_zsh/$zsh_config_file"
        print_result "$?" "$module_name_highlight | Copy ZSH config file $zsh_config_file_highlight in $dotfiles_dir_zsh_highlight!"
    done

    create_symlink "$module_name_highlight" "zshenv" "$dotfiles_dir_zsh/zshenv" "$HOME/.zshenv"
    create_symlink "$module_name_highlight" "zshrc" "$dotfiles_dir_zsh/zshrc" "$HOME/.zshrc"
}

fix_insecure_directories() {
    :
    # compaudit | xargs chmod g-w,o-w
}

change_default_shell() {
    :
}

__init__() {
    print_cat "Backup zsh configuration first!"
    backup_existing_zsh

    print_cat "Installation of zsh framework oh-my-zsh"
    install_oh_my_zsh

    print_cat "Installation of usefull oh-my-zsh plugins"
    install_oh_my_zsh_plugins

    print_cat "Installation of oh-my-zsh theme Powerlevel10k"
    install_oh_my_zsh_theme_p10k

    print_cat "Configuration of ZSH"
    configure_zsh
}

__init__
