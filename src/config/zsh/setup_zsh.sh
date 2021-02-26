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
    ZSH_DIR="$ROOT_DIR"
else
    ZSH_DIR="$ROOT_DIR/src/config/zsh"
fi

# === Directory where the ZSH settings files should be stored === /
DOTFILES_ZSH_DIR="$DOTFILES_DIR/zsh"
mkdir -p "$DOTFILES_ZSH_DIR" &>/dev/null && chmod 700 "$DOTFILES_ZSH_DIR" # == Create new folder to store ZSH settings == /
DOTFILES_ZSH_DIR_NAME=$(print_highlight "$DOTFILES_ZSH_DIR")

backup_existing_zsh() {
    declare -r MODULE=$(print_highlight "ZSH-Bkp")
    declare -r BACKUP_ZSH_DIR="$BACKUP_DIR/zsh"
    declare -r BACKUP_ZSH_DIR_NAME=$(print_highlight "$BACKUP_ZSH_DIR")

    local ZSH_FILES=(".zshenv" ".zprofile" ".zshrc" ".zlogin" ".zlogout" ".zsh_history")

    ask_for_confirmation "Should I backup the current ZSH configuration files now?"
    if ! answer_is_yes; then
        return 1
    fi

    for file in "${ZSH_FILES[@]}"; do
        local file_name=$(print_highlight "$file")

        # == If the zsh file not exists == /
        if [[ ! -e "$HOME/$file" ]]; then
            print_fail "$MODULE | File $file_name not found, will not be backed up!"
        # == If the zsh file exist == /
        else
            print_run "$MODULE | Backing up ZSH config file $file_name to $BACKUP_ZSH_DIR_NAME!"
            mkdir -p "$BACKUP_ZSH_DIR" &>/dev/null && chmod 700 "$BACKUP_ZSH_DIR"
            mv "$HOME/$file" "$BACKUP_ZSH_DIR" &>/dev/null
            print_result "$?" "$MODULE | Backed up your ZSH config file $file_name to $BACKUP_ZSH_DIR_NAME!"
        fi
    done
}

install_oh_my_zsh() {
    declare -r MODULE=$(print_highlight "OMZ")

    ask_for_confirmation "Should I install oh-my-zsh now?"
    if ! answer_is_yes; then
        return 1
    fi

    print_run "$MODULE | Installing zsh framework $(print_highlight "oh-my-zsh")!"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    print_result "$?" "$MODULE | Installation of zsh framework $(print_highlight "oh-my-zsh")!"
}

install_oh_my_zsh_plugins() {
    declare -r MODULE=$(print_highlight "OMZ-Plugins")

    ask_for_confirmation "Should I install oh-my-zsh plugins now?"
    if ! answer_is_yes; then
        return 1
    fi

    print_run "$MODULE | Installing oh-my-zsh plugin $(print_highlight "zsh-autosuggestions") now!"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions &>/dev/null
    print_result "$?" "$MODULE | Installation of oh-my-zsh plugin $(print_highlight "zsh-autosuggestions")!"

    print_run "$MODULE | Installing oh-my-zsh plugin $(print_highlight "zsh-syntax-highlighting") now!"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting &>/dev/null
    print_result "$?" "$MODULE | Installation of oh-my-zsh plugin $(print_highlight "zsh-syntax-highlighting")!"
}

install_oh_my_zsh_theme_p10k() {
    declare -r MODULE=$(print_highlight "OMZ-Theme")

    ask_for_confirmation "Should I install the oh-my-zsh theme Powerlevel10k now?"
    if ! answer_is_yes; then
        return 1
    fi

    print_run "$MODULE | Installing oh-my-zsh theme $(print_highlight "Powerlevel10k") now!"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k &>/dev/null
    print_result "$?" "$MODULE | Installation of oh-my-zsh theme $(print_highlight "Powerlevel10k")!"

    [[ -e ~/.p10k.zsh ]] && rm ~/.p10k.zsh # Remove unnecessary default config file for p10k
}

configure_zsh() {
    declare -r MODULE=$(print_highlight "ZSH")

    local ZSH_FILES=("zshenv.link" "zshrc.link" "p10k.zsh" "aliases" "functions")

    ask_for_confirmation "Should I configure ZSH now?"
    if ! answer_is_yes; then
        return 1
    fi

    for file in "${ZSH_FILES[@]}"; do
        local FILE_NAME=$(print_highlight "$file")

        print_run "$MODULE | Copy ZSH config file $FILE_NAME in $DOTFILES_ZSH_DIR_NAME!"
        cp "$ZSH_DIR/example/$file" "$DOTFILES_ZSH_DIR/$file"
        print_result "$?" "$MODULE | Copy ZSH config file $FILE_NAME in $DOTFILES_ZSH_DIR_NAME!"
    done

    create_symlink "$MODULE" "zshenv" "$DOTFILES_ZSH_DIR/zshenv.link" "$HOME/.zshenv"
    create_symlink "$MODULE" "zshrc" "$DOTFILES_ZSH_DIR/zshrc.link" "$HOME/.zshrc"
}

change_default_shell() {
    :
}

__init__() {
    print_cat "Backup zsh configuration first!"
    backup_existing_zsh

    print_cat "Installation of zsh framework oh-my-zsh"
    install_oh_my_zsh

    print_cat "Installation of oh-my-zsh theme Powerlevel10k"
    install_oh_my_zsh_theme_p10k

    print_cat "Configuration of ZSH"
    configure_zsh
}

__init__
