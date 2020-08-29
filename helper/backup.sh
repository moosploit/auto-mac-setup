#!/bin/bash
# ================================================================================
# -- File:          helper/backup.sh
# -- Project:       auto-mac-setup
# -- Project URL:   https://github.com/moosploit/auto-mac-setup
# -- Create Date:   2020-04-19 11:41
# -- Author:        Michael Linder
# -- Company:       moosploit.com
# -- License:       MIT License | http://www.opensource.org/licenses/MIT
# ================================================================================

# Backup homebrew
function bkp_homebrew() {
    brew_bkp_folder=$HOME"/backup/install/homebrew"
    mkdir -p $brew_bkp_folder

    brew leaves > $brew_bkp_folder"/brew-list.txt"
    brew cask list -1 > $brew_bkp_folder"/brew-cask-list.txt"
}

# Backup Mac App Store
function bkp_mas() { 
    mas_bkp_folder=$HOME"/backup/install/mas"
    mkdir -p $mas_bkp_folder

    mas list > $mas_bkp_folder"/mas-list.txt"
    mas list | cut -d " " -f 1 > $mas_bkp_folder"/mas-list-ids.txt"
}

# Backup current dotfiles
#TODO bring the function to work
function bkp_dofiles() {
    mkdir -p ~/backup/dotfiles
}