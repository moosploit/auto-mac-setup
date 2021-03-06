#!/bin/bash
# ============================================================================
# -- File:          vscode/setup_vscode.sh
# -- Project:       auto-mac-setup
# -- Project URL:   https://github.com/moosploit/auto-mac-setup
# -- Create Date:   2020-09-18 14:57
# -- Author:        moosploit
# -- License:       MIT License | http://www.opensource.org/licenses/MIT
# ============================================================================

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
mkdir -p "$DOTFILES_VSCODE_DIR" &>/dev/null # == Create new folder to store VSCode settings == /
DOTFILES_VSCODE_DIR_NAME=$(print_highlight "$DDOTFILES_VSCODE_DIR")

vscode_install_ext() {
    # vscode_install_ext EXTENSION
    declare -r EXT=$1                             # Extension
    declare -r EXT_NAME=$(print_highlight "$EXT") # Extension Name
    declare -r MODULE=$(print_highlight "VSCode") # Module Name

    # == Check if enough arguments specified == /
    if [[ "$#" -lt 1 ]]; then
        print_fail "There are not enough arguments specified for 'vscode_install_ext'! "
        return 1
    fi

    if test "$(which code)"; then
        code --list-extensions | grep "$EXT" -i &>/dev/null
        if [[ "$?" -eq 0 ]]; then
            print_success "$MODULE | Extension $EXT_NAME is already installed!"
            return 2
        fi
    else
        print_error "Application $MODULE is not installed!"
        return 99
    fi

    # == Install MAS App == /
    print_run "$MODULE | Installing extension $EXT_NAME!"
    code --install-extension "$EXT" &>/dev/null
    print_result "$?" "$MODULE | Installation of extension $EXT_NAME"

}

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

setup_config() {
    declare -r MODULE=$(print_highlight "VSCode")

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

    copy_it_to "$MODULE" "settings.json" "$SETTINGS_FILE" "$DOTFILES_VSCODE_DIR/settings.json"
    create_symlink "$MODULE" "settings.json" "$DOTFILES_VSCODE_DIR/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"

    copy_it_to "$MODULE" "keybindings.json" "$KEYBINDINGS_FILE" "$DOTFILES_VSCODE_DIR/keybindings.json"
    create_symlink "$MODULE" "keybindings.json" "$DOTFILES_VSCODE_DIR/keybindings.json" "$HOME/Library/Application Support/Code/User/keybindings.json"

    copy_it_to "$MODULE" "snippets/" "$SNIPPETS_DIR" "$DOTFILES_VSCODE_DIR"
    create_symlink "$MODULE" "snippets/" "$DOTFILES_VSCODE_DIR/snippets" "$HOME/Library/Application Support/Code/User/snippets"

    kill_app Electron
}

__init__() {
    print_cat "Installation of VSCode extensions!"
    install_extensions

    print_cat "Setting up application VSCode!"
    setup_config
}

__init__
