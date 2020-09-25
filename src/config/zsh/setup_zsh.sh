#!/bin/bash
# ================================================================================
# -- File:          zsh/setup_zsh.sh
# -- Project:       auto-mac-setup
# -- Project URL:   https://github.com/moosploit/auto-mac-setup
# -- Create Date:   2020-09-25 11:18
# -- Author:        Michael Linder
# -- Company:       moosploit.com
# -- License:       MIT License | http://www.opensource.org/licenses/MIT
# ================================================================================

# Check whether the script is called directly or via source
if [[ $(basename ${0}) == $(basename ${BASH_SOURCE}) ]]; then
	source ../../../helper/output.sh
	source ../../../helper/utils.sh
	source ../../../helper/global_variables.sh
	ZSH_DIR="$ROOT_DIR"
else
	ZSH_DIR="$ROOT_DIR/src/config/ZSH"
fi

# === Directory where the ZSH settings files should be stored === /
DOTFILES_ZSH_DIR="$DOTFILES_DIR/zsh"
mkdir -p "$DOTFILES_ZSH_DIR" &>/dev/null # == Create new folder to store ZSH settings == /
DOTFILES_ZSH_DIR_NAME=$(print_highlight "$DOTFILES_ZSH_DIR")

__init__() {
	:
}

__init__
