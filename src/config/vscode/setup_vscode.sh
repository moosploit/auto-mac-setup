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
    project_dir_vscode="$ROOT_DIR"
else
    project_dir_vscode="$ROOT_DIR/src/config/vscode"
fi

# === Directory where the VSCode settings files should be stored === /
dotfiles_dir_vscode="$DOTFILES_DIR/vscode"
dotfiles_dir_vscode_highlight=$(print_highlight "$dotfiles_dir_vscode")
# == Create new folder to store VSCode settings == /
mkdir -p "$dotfiles_dir_vscode" &>/dev/null

vscode_install_ext() {
    declare -r module_name=$(print_highlight "VSCode")                       # Module Name
    declare -r extension_name=$1                                             # Extension Name
    declare -r extension_name_highlight=$(print_highlight "$extension_name") # Extension Name Highlighted

    # == Check if enough arguments specified == /
    if [[ "$#" -lt 1 ]]; then
        print_fail "There are not enough arguments specified for 'vscode_install_ext'! "
        return 1
    fi

    if test "$(which code)"; then
        code --list-extensions | grep "$extension_name" -i &>/dev/null
        if [[ "$?" -eq 0 ]]; then
            print_success "$module_name | Extension $extension_name_highlight is already installed!"
            return 2
        fi
    else
        print_error "Application $module_name is not installed!"
        return 99
    fi

    # == Install MAS App == /
    print_run "$module_name | Installing extension $extension_name_highlight!"
    code --install-extension "$extension_name" &>/dev/null
    print_result "$?" "$module_name | Installation of extension $extension_name_highlight"

}

install_extensions() {
    ask_for_confirmation "Should I install the extensions now?"
    if ! answer_is_yes; then
        return 1
    fi

    cat $project_dir_vscode/extensions.txt | while read line; do
        vscode_install_ext "$line"
    done

    kill_app Electron
}

setup_config() {
    declare -r module_name=$(print_highlight "VSCode")

    local vscode_file_settings=""
    local vscode_file_keybindings=""
    local vscode_dir_snippets=""

    ask_for_confirmation "Should I setup the configuration now?"
    if ! answer_is_yes; then
        return 1
    fi

    ask_for_confirmation "Should I use the default settings?"
    # == Copy the default files from this folder and symlink them to the origin
    if answer_is_yes; then
        vscode_file_settings="$project_dir_vscode/example/settings.json"
        vscode_file_keybindings="$project_dir_vscode/example/keybindings.json"
        vscode_dir_snippets="$project_dir_vscode/example/snippets"
    # == Copy the original files and symlink them to the origin
    else
        vscode_file_settings="$HOME/Library/Application Support/Code/User/settings.json"
        vscode_file_keybindings="$HOME/Library/Application Support/Code/User/keybindings.json"
        vscode_dir_snippets="$HOME/Library/Application Support/Code/User/snippets"
    fi

    copy_it_to "$module_name" "settings.json" "$vscode_file_settings" "$dotfiles_dir_vscode/settings.json"
    create_symlink "$module_name" "settings.json" "$dotfiles_dir_vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"

    copy_it_to "$module_name" "keybindings.json" "$vscode_file_keybindings" "$dotfiles_dir_vscode/keybindings.json"
    create_symlink "$module_name" "keybindings.json" "$dotfiles_dir_vscode/keybindings.json" "$HOME/Library/Application Support/Code/User/keybindings.json"

    copy_it_to "$module_name" "snippets/" "$vscode_dir_snippets" "$dotfiles_dir_vscode"
    create_symlink "$module_name" "snippets/" "$dotfiles_dir_vscode/snippets" "$HOME/Library/Application Support/Code/User/snippets"

    kill_app Electron
}

__init__() {
    print_cat "Installation of VSCode extensions!"
    install_extensions

    print_cat "Setting up application VSCode!"
    setup_config
}

__init__
