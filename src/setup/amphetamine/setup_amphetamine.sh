#!/bin/bash
# ============================================================================
# -- File:          amphetamine/setup_amphetamine.sh
# -- Project:       auto-mac-setup
# -- Project URL:   https://github.com/moosploit/auto-mac-setup
# -- Create Date:   2021-03-11 17:26
# -- Author:        moosploit
# -- License:       MIT License | http://www.opensource.org/licenses/MIT
# ============================================================================

# Check whether the script is called directly or via source
if [[ $(basename ${0}) == $(basename ${BASH_SOURCE}) ]]; then
    source ../../../helper/output.sh
    source ../../../helper/utils.sh
    source ../../../helper/global_variables.sh
    projet_dir_amphetamine="$ROOT_DIR"
else
    projet_dir_amphetamine="$ROOT_DIR/src/setup/amphetamine"
fi

general_setup() {
    ask_for_confirmation "Should I setup Amphetamine now?"
    if ! answer_is_yes; then
        return 1
    fi

    # === Amphetamine > Settings > General > Show Welcome Window [0=No|1=Yes] === /
    defaults_write "Amphetamine" "com.if.Amphetamine" "Show Welcome Window" "int" "0"

    # === Amphetamine > Settings > General > Start Session when Amphetamine launches [0=No|1=Yes] === /
    defaults_write "Amphetamine" "com.if.Amphetamine" "Start Session At Launch" "int" "1"

    # === Amphetamine > Settings > General > Start Session after waking from sleep [0=No|1=Yes] === /
    defaults_write "Amphetamine" "com.if.Amphetamine" "Start Session On Wake" "int" "1"

    # === Amphetamine > Settings > Sessions > Forced Sleep: End Session when Mac is foreced to sleep [0=No|1=Yes] === /
    defaults_write "Amphetamine" "com.if.Amphetamine" "End Sessions On Forced Sleep" "int" "1"

    # === Amphetamine > Settings > Sessions > Default Duration [0=Indefinitely] === /
    defaults_write "Amphetamine" "com.if.Amphetamine" "Default Duration" "int" "0"

    # === Amphetamine > Settings > Sessions > Allow System sleep when display is closed [0=Yes|1=No] === /
    defaults_write "Amphetamine" "com.if.Amphetamine" "Suppress Closed Display Warning" "int" "0"

    # === Amphetamine > Settings > Sessions > Battery: End Session if charge is below [0=No|1=Yes] === /
    defaults_write "Amphetamine" "com.if.Amphetamine" "End Session On Low Battery" "int" "1"

    # === Amphetamine > Settings > Sessions > Battery: Battery percent === /
    defaults_write "Amphetamine" "com.if.Amphetamine" "Low Battery Percent" "int" "10"

    # === Amphetamine > Settings > Sessions > Battery: Prompt before ending a session [0=No|1=Yes] === /
    defaults_write "Amphetamine" "com.if.Amphetamine" "Always Ask to End For Low Battery" "int" "1"

    # === Amphetamine > Settings > Sessions > Power Adapter: Ignore charge if power adapter is connected [0=No|1=Yes] === /
    defaults_write "Amphetamine" "com.if.Amphetamine" "Ignore Battery on AC" "int" "1"

    # === Amphetamine > Settings > Sessions > Power Adapter: Start a new session if reconnected [0=No|1=Yes] === /
    defaults_write "Amphetamine" "com.if.Amphetamine" "Restart DD Session on AC Reconnect" "int" "1"

    # === Amphetamine > Settings > Sessions:All Sessions > Lock Screen: Allow display sleep when screen is locked [0=No|1=Yes] === /
    defaults_write "Amphetamine" "com.if.Amphetamine" "Allow Display Sleep When Screen Is Locked" "int" "1"

    # === Amphetamine > Settings > Drive Alive > Enable Drive Alive [0=No|1=Yes] === /
    defaults_write "Amphetamine" "com.if.Amphetamine" "Enable Drive Alive" "int" "0"

    # === Amphetamine > Settings > Notifications > Triggers/Scheduled: Notify when Trigger/scheduled sessions auto-start [0=No|1=Yes] === /
    defaults_write "Amphetamine" "com.if.Amphetamine" "Enable Session Auto Start Notifications" "int" "0"

    # === Amphetamine > Settings > Notifications > Triggers/Scheduled: Notify when Trigger/scheduled sessions auto-end [0=No|1=Yes] === /
    defaults_write "Amphetamine" "com.if.Amphetamine" "Enable Session Auto End Notifications" "int" "0"

    # === Amphetamine > Settings > Notifications > Sound: Play with session reminder/other notifications [0=No|1=Yes] === /
    defaults_write "Amphetamine" "com.if.Amphetamine" "Enable Notification Sound" "int" "0"

    # === Amphetamine > Settings > Notifications > Sound: Play when any session starts or ends [0=No|1=Yes] === /
    defaults_write "Amphetamine" "com.if.Amphetamine" "Enable Session State Sound" "int" "0"

    # === Amphetamine > Settings > Apperance > Menu Bar Image === /
    defaults_write "Amphetamine" "com.if.Amphetamine" "Icon Style" "int" "5"

    # === Amphetamine > Settings > Apperance > Menu Extras: Show current session details [0=No|1=Yes] === /
    defaults_write "Amphetamine" "com.if.Amphetamine" "Show Session Details In Menu" "int" "1"

    # === Amphetamine > Settings > Apperance > Menu Bar Image: Use low opacity when inactive [0=No|1=Yes] === /
    defaults_write "Amphetamine" "com.if.Amphetamine" "Lower Icon Opacity" "int" "1"

    kill_app Amphetamine
    open -a Amphetamine
}

__init__() {
    print_cat "Setting up application Amphetamine!"
    general_setup
}

__init__
