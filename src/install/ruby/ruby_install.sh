#!/bin/bash
# ============================================================================
# -- File:          ruby/ruby_install.sh
# -- Project:       auto-mac-setup
# -- Project URL:   https://github.com/moosploit/auto-mac-setup
# -- Create Date:   2020-11-15 22:44
# -- Author:        moosploit
# -- License:       MIT License | http://www.opensource.org/licenses/MIT
# ============================================================================

# Check whether the script is called directly or via source
if [[ $(basename ${0}) == $(basename ${BASH_SOURCE}) ]]; then
    source ../../../helper/output.sh
    source ../../../helper/utils.sh
fi

# === Ruby Wrapper Functions === /
ruby_install() {
    declare -r ruby_formula_name_highlight=$(print_highlight "$1")
    declare -r ruby_formula="$2"
    declare -r module_name_highlight=$(print_highlight "Ruby-Install")

    if [[ "$#" -lt 2 ]]; then
        print_fail "There are not enough arguments specified for 'ruby_install'! "
        return 1
    fi

    # == Check if ruby formula already installed == /
    gem list "$ruby_formula" &>/dev/null
    if [[ "$?" -eq 0 ]]; then
        print_success "$module_name_highlight | Formula $ruby_formula_name_highlight is already installed!"
        return 2
    fi

    # == Install ruby formula == /
    print_run "$module_name_highlight | Installing formula $ruby_formula_name_highlight!"
    sudo gem install "$ruby_formula" &>/dev/null
    print_result "$?" "$module_name_highlight | Installation of formula $ruby_formula_name_highlight"
}

__init__() {
    ask_for_sudo

    print_cat "Ruby | Install some usefull 'CLI Tools'"
    ruby_install "ColorLS" "colorls"
}

__init__
