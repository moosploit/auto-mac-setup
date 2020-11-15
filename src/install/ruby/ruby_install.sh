#!/bin/bash
# ================================================================================
# -- File:          ruby/ruby_install.sh
# -- Project:       auto-mac-setup
# -- Project URL:   https://github.com/moosploit/auto-mac-setup
# -- Create Date:   2020-11-15 22:44
# -- Author:        Michael Linder
# -- Company:       moosploit.com
# -- License:       MIT License | http://www.opensource.org/licenses/MIT
# ================================================================================

# Check whether the script is called directly or via source
if [[ $(basename ${0}) == $(basename ${BASH_SOURCE}) ]]; then
	source ../../../helper/output.sh
	source ../../../helper/utils.sh
fi

__init__() {
	ask_for_sudo

	print_cat "Ruby | Install some usefull 'CLI Tools'"
	ruby_install "ColorLS" "colorls"
}

__init__
