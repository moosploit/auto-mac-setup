#!/bin/bash
# ================================================================================
# -- File:          helper/spinner.sh
# -- Project:       auto-mac-setup
# -- Project URL:   https://github.com/moosploit/auto-mac-setup
# -- Create Date:   2020-09-01 17:13
# -- Author:        Michael Linder
# -- Company:       moosploit.com
# -- License:       MIT License | http://www.opensource.org/licenses/MIT
# ================================================================================

# Loading spinner animation
spinner() {
	local -r chars="/-\|"

	while :; do
		for (( i=0; i<${#chars}; i++ )); do
			sleep 0.2
			echo -en "[${chars:$i:1}]" "\r"
		done
	done
}