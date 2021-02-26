#!/bin/bash
# ============================================================================
# -- File:          xcode/xcode_install.sh
# -- Project:       auto-mac-setup
# -- Project URL:   https://github.com/moosploit/auto-mac-setup
# -- Create Date:   2020-08-29 13:44
# -- Author:        moosploit
# -- License:       MIT License | http://www.opensource.org/licenses/MIT
# ============================================================================

# Check whether the script is called directly or via source
if [[ $(basename ${0}) == $(basename ${BASH_SOURCE}) ]]; then
    source ../../../helper/output.sh
    source ../../../helper/utils.sh
fi

check_is_xcode_installed() {
    [ -d "/Applications/Xcode.app" ]
}

check_are_xcode_clts_installed() {
    xcode-select --print-path &>/dev/null
}

accept_xcode_license() {
    declare -r MODULE=$(print_highlight "XCode")

    # Automatically agree to the terms of the `Xcode` license.
    # https://github.com/alrra/dotfiles/issues/10

    sudo xcodebuild -license accept &>/dev/null
    print_result "$?" "$MODULE | Agree to the terms of Xcode license"
}

install_xcode() {
    declare -r MODULE=$(print_highlight "XCode")

    if ! check_is_xcode_installed; then
        print_run "$MODULE | Open Mac App Store and click install Xcode please!"
        open "macappstores://apps.apple.com/us/app/xcode/id497799835"

        until check_is_xcode_installed; do
            sleep 5
        done

        print_result "$?" "$MODULE | Installation of Apple Xcode!"
    else
        print_success "$MODULE | Application Apple Xcode is already installed!"
    fi
}

install_xcode_ctls() {
    declare -r MODULE=$(print_highlight "XCode")

    if ! check_are_xcode_clts_installed; then
        print_run "$MODULE | Command line developer tools will be installed!"

        # Install xcode command line developer tools
        xcode-select --install &>/dev/null

        # Check whether the installation has finished
        until check_are_xcode_clts_installed; do
            sleep 5
        done

        print_result "$?" "$MODULE | Command line developer tools installation."
    else
        print_success "$MODULE | Command line developer tools are already installed!"
    fi
}

set_xcode_dev_dir() {
    declare -r CURR_DEV_DIR=$(xcode-select -p)
    declare -r NEW_DEV_DIR="/Applications/Xcode.app/Contents/Developer"
    declare -r MODULE=$(print_highlight "XCode")

    if [[ $CURR_DEV_DIR == $NEW_DEV_DIR ]]; then
        print_success "$MODULE | Active developer directory already set!"
        return 1
    fi

    print_run "$MODULE | Setting active developer directory!"
    # sudo xcode-select --switch /Library/Developer/CommandLineTools &>/dev/null
    sudo xcode-select -switch "/Applications/Xcode.app/Contents/Developer" &>/dev/null
    print_result $? "$MODULE | Set active developer directory!"
}

__init__() {
    ask_for_sudo

    print_cat "Now let's check whether the Xcode command line developer tools are installed."
    install_xcode_ctls

    print_cat "Ok next step will be the installation of Xcode!"
    install_xcode

    print_cat "We will now set the Xcode development directory!"
    set_xcode_dev_dir

    print_cat "After all we have to accept the Xcode license! "
    accept_xcode_license
}

__init__
