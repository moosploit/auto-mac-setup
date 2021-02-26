#!/bin/bash
# ============================================================================
# -- File:          git/setup_git.sh
# -- Project:       auto-mac-setup
# -- Project URL:   https://github.com/moosploit/auto-mac-setup
# -- Create Date:   2020-09-25 11:50
# -- Author:        moosploit
# -- License:       MIT License | http://www.opensource.org/licenses/MIT
# ============================================================================

# Check whether the script is called directly or via source
if [[ $(basename ${0}) == $(basename ${BASH_SOURCE}) ]]; then
    source ../../../helper/output.sh
    source ../../../helper/utils.sh
    source ../../../helper/global_variables.sh
    GIT_DIR="$ROOT_DIR"
else
    GIT_DIR="$ROOT_DIR/src/config/git"
fi

# === Directory where the GIT settings files should be stored === /
DOTFILES_GIT_DIR="$DOTFILES_DIR/git"
mkdir -p "$DOTFILES_GIT_DIR" &>/dev/null && chmod 700 "$DOTFILES_GIT_DIR" # == Create new folder to store GIT settings == /
DOTFILES_GIT_DIR_NAME=$(print_highlight "$DOTFILES_GIT_DIR")

backup_existing_git() {
    declare -r MODULE=$(print_highlight "GIT-Bkp")
    declare -r BACKUP_GIT_DIR="$BACKUP_DIR/git"
    declare -r BACKUP_GIT_DIR_NAME=$(print_highlight "$BACKUP_GIT_DIR")

    local GIT_FILES=(".gitconfig" ".gitignore" ".gitconfig.local" ".gitattributes" ".gitmodules")

    ask_for_confirmation "Should I backup the current GIT configuration files now?"
    if ! answer_is_yes; then
        return 1
    fi

    for file in "${GIT_FILES[@]}"; do
        local file_name=$(print_highlight "$file")

        # == If the git file not exists == /
        if [[ ! -e "$HOME/$file" ]]; then
            print_fail "$MODULE | File $file_name not found, will not be backed up!"
        # == If the git file exist == /
        else
            print_run "$MODULE | Backing up GIT config file $file_name to $BACKUP_GIT_DIR_NAME!"
            mkdir -p "$BACKUP_GIT_DIR" &>/dev/null && chmod 700 "$BACKUP_GIT_DIR"
            mv "$HOME/$file" "$BACKUP_GIT_DIR" &>/dev/null
            print_result "$?" "$MODULE | Backed up your GIT config file $file_name to $BACKUP_GIT_DIR_NAME!"
        fi
    done
}

get_gitignore() {
    curl -sL https://www.toptal.com/developers/gitignore/api/$@
}

create_global_gitmessage() {
    declare -r MODULE=$(print_highlight "GIT")

    ask_for_confirmation "Should I create the default git commit message file?"
    if ! answer_is_yes; then
        return 1
    fi

    copy_it_to "$MODULE" "Git commit message template" "$GIT_DIR/example/gitmessage.txt" "$DOTFILES_GIT_DIR/gitmessage.txt"
}

create_global_gitignore() {
    declare -r MODULE=$(print_highlight "GIT")
    declare -r GI_LIST="macos,linux,zsh,homebrew,visualstudiocode,xcode,python,jupyternotebooks,ruby,node,typo3,codekit"

    ask_for_confirmation "Should I create new default global gitignore file now?"
    if ! answer_is_yes; then
        return 1
    fi

    print_run "$MODULE | Creating new default global gitignore file."
    get_gitignore "$GI_LIST" >"$DOTFILES_GIT_DIR/gitignore" #&>/dev/null
    print_result "$?" "$MODULE | Created default global gitignore file"
}

create_personel_gitconfig() {
    declare -r MODULE=$(print_highlight "GIT")

    local GIT_USER=""
    local GIT_USER_MAIL=""
    local GIT_USER_SIGNKEY=""

    ask_for_confirmation "Should I setup the personel gitconfig file now?"
    if ! answer_is_yes; then
        return 1
    fi

    ask_for_confirmation "Should I use $(print_highlight "$(get_full_username)") as your user name?"
    if ! answer_is_yes; then
        while [[ -z "$GIT_USER" ]]; do
            ask_for_input "Please provide your user name now:"
            if [[ -n "$REPLY" ]]; then
                GIT_USER="$REPLY"
                print_result "$?" "$MODULE | User name set to $(print_highlight "$REPLY")"
            fi
        done
    else
        GIT_USER="$(get_full_username)"
        print_result "$?" "$MODULE | User name set to $(print_highlight "$(get_full_username)")"
    fi

    while [[ -z "$GIT_USER_MAIL" ]]; do
        ask_for_input "Please provide a email address which should be used:"
        if [[ -n "$REPLY" ]]; then
            GIT_USER_MAIL="$REPLY"
        fi
    done

    ask_for_input "Please provide your gpg signing key or leave it blank:"
    if [[ -n "$REPLY" ]]; then
        GIT_USER_SIGNKEY="$REPLY"
    fi

    print_run "$MODULE | Creating personel gitconfig file in $DOTFILES_GIT_DIR_NAME!"
    printf "%b\n" \
        "[user]\n	name = $GIT_USER\n	email = $GIT_USER_MAIL\n	signingKey = $GIT_USER_SIGNKEY\n" >"$DOTFILES_GIT_DIR/gitconfig.local"
    print_result "$?" "$MODULE | Created personel gitconfig file in $DOTFILES_GIT_DIR_NAME!"
}

setup_global_gitconfig() {
    declare -r MODULE=$(print_highlight "GIT")

    ask_for_confirmation "Should I setup the global gitconfig now?"
    if ! answer_is_yes; then
        return 1
    fi

    print_run "$MODULE | Creating global gitconfig file in $DOTFILES_GIT_DIR_NAME!"
    cp "$GIT_DIR/example/gitconfig" "$DOTFILES_GIT_DIR/gitconfig"
    print_result "$?" "$MODULE | Created global gitconfig file in $DOTFILES_GIT_DIR_NAME!"

    create_symlink "$MODULE" "gitconfig" "$DOTFILES_GIT_DIR/gitconfig" "$HOME/.gitconfig"
}

__init__() {
    print_cat "Backup git configuration first!"
    backup_existing_git

    print_cat "Setting up global gitignore file!"
    create_global_gitignore

    print_cat "Setting up global git commit message template!"
    create_global_gitmessage

    print_cat "Setting up personel gitconfig file!"
    create_personel_gitconfig

    print_cat "Setting up global gitconfig file!"
    setup_global_gitconfig
}

__init__
