#!/bin/bash
# ============================================================================
# -- File:          spotify/setup_spotify.sh
# -- Project:       auto-mac-setup
# -- Project URL:   https://github.com/moosploit/auto-mac-setup
# -- Create Date:   2021-03-12 15:47
# -- Author:        moosploit
# -- License:       MIT License | http://www.opensource.org/licenses/MIT
# ============================================================================

# Check whether the script is called directly or via source
if [[ $(basename ${0}) == $(basename ${BASH_SOURCE}) ]]; then
    source ../../../helper/output.sh
    source ../../../helper/utils.sh
    source ../../../helper/global_variables.sh
    project_dir_spotify="$ROOT_DIR"
else
    project_dir_spotify="$ROOT_DIR/src/setup/spotify"
fi

general_setup() {
    ask_for_confirmation "Should I setup Spotify now?"
    if ! answer_is_yes; then
        return 1
    fi

    # === Spotify > Settings > Boot and Window > Open Spotify at launch automatically [true|false] === /
    defaults_write "Spotify" "com.spotify.client" "AutoStartSettingIsHidden" "bool" "false"

    kill_app Spotify
}

__init__() {
    print_cat "Setting up application Spotify!"
    general_setup
}

__init__
