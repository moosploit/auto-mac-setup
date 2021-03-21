#!/bin/bash
# ============================================================================
# -- File:          auto-mac-setup/setup.sh
# -- Project:       auto-mac-setup
# -- Project URL:   https://github.com/moosploit/auto-mac-setup
# -- Create Date:   2020-08-28 11:58
# -- Author:        moosploit
# -- License:       MIT License | http://www.opensource.org/licenses/MIT
# ============================================================================

source ./helper/utils.sh
source ./helper/output.sh
source ./helper/global_variables.sh

__init__() {
    print_cat "Meow $(get_full_username)!" "I will help you to auto configure your new Apple Mac."
    ask_for_confirmation "Shall we procced?"

    if ! answer_is_yes; then
        print_cat "OK! Hope you'll come back soon."
        exit
    fi

    print_cat "Purrrrrrfect! - Let us begin."

    # === Install Xcode and Xcode Development Tools === /
    source ./src/install/xcode/install_xcode.sh

    # === Install Applications via Homebrew === /
    source ./src/install/homebrew/install_brew.sh

    # === Install Applications via Ruby === /
    source ./src/install/ruby/install_ruby.sh

    # === Install Applications via Mac App Store === /
    source ./src/install/mas/install_mas.sh

    # === Configure macOS === /
    source ./src/setup/macos/setup_macos.sh

    # === Configure Application ForkLift 3 === /
    source ./src/setup/forklift/setup_forklift.sh

    # === Configure Application Moom === /
    source ./src/setup/moom/setup_moom.sh

    # === Configure Application Iterm2 === /
    source ./src/setup/iterm/setup_iterm.sh

    # === Configure Application Visual Studio Code === /
    source ./src/setup/vscode/setup_vscode.sh

    # === Configure SSH === /
    source ./src/setup/ssh/setup_ssh.sh

    # === Configure GIT === /
    source ./src/setup/git/setup_git.sh
}

__init__
