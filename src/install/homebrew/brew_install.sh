#!/bin/bash
# ================================================================================
# -- File:          homebrew/brew_install.sh
# -- Project:       auto-mac-setup
# -- Project URL:   https://github.com/moosploit/auto-mac-setup
# -- Create Date:   2020-08-28 13:07
# -- Author:        Michael Linder
# -- Company:       moosploit.com
# -- License:       MIT License | http://www.opensource.org/licenses/MIT
# ================================================================================

# Check whether the script is called directly or via source
$(return &> /dev/null)

if [ "$?" -ne "0" ]; then
    source ../../../helper/output.sh
    source ../../../helper/utils.sh
fi

main() {
    print_success "yeah"
}

main