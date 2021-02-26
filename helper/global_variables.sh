#!/bin/bash
# ============================================================================
# -- File:          helper/global_variables.sh
# -- Project:       auto-mac-setup
# -- Project URL:   https://github.com/moosploit/auto-mac-setup
# -- Create Date:   2020-09-19 14:51
# -- Author:        moosploit
# -- License:       MIT License | http://www.opensource.org/licenses/MIT
# ============================================================================

# === Root directory of the script === /
ROOT_DIR=$(pwd -P)

# === Dotfiles directory where the settings will be stored === /
DOTFILES_DIR="$HOME/.dotfiles"
mkdir -p "$DOTFILES_DIR" && chmod 700 "$DOTFILES_DIR"

# === Backup directory where the current settings will be backed up === /
BKP_DATE=$(date +"%Y-%m-%d-%H%M%S")
BACKUP_DIR="$DOTFILES_DIR/_backup/$BKP_DATE"
