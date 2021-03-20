#!/bin/bash
# ============================================================================
# -- File:          forklift/setup_forklift.sh
# -- Project:       auto-mac-setup
# -- Project URL:   https://github.com/moosploit/auto-mac-setup
# -- Create Date:   2020-09-16 19:18
# -- Author:        moosploit
# -- License:       MIT License | http://www.opensource.org/licenses/MIT
# ============================================================================

# Check whether the script is called directly or via source
if [[ $(basename ${0}) == $(basename ${BASH_SOURCE}) ]]; then
    source ../../../helper/output.sh
    source ../../../helper/utils.sh
    source ../../../helper/global_variables.sh
    project_dir_forklift="$ROOT_DIR"
else
    project_dir_forklift="$ROOT_DIR/src/setup/forklift"
fi

general_setup() {
    ask_for_confirmation "Should I setup ForkLift now?"
    if ! answer_is_yes; then
        return 1
    fi

    # == Forklift 3 > Settings > General > Default Path [true|false] ==/
    defaults_write "ForkLift" "com.binarynights.ForkLift-3" "DefaultPath" "string" "${HOME}"

    # == Forklift 3 > Settings > General > Restore tabs and windows at start [true|false] ==/
    defaults_write "ForkLift" "com.binarynights.ForkLift-3" "RestoreWindows" "bool" "true"

    # == Forklift 3 > Settings > General > Confirm drag operations [true|false] ==/
    defaults_write "ForkLift" "com.binarynights.ForkLift-3" "ConfirmDragOperations" "bool" "false"

    # == Forklift 3 > Settings > General > Application Deleter [true|false] ==/
    defaults_write "ForkLift" "com.binarynights.ForkLift-3" "ApplicationDeleter" "bool" "true"

    # == Forklift 3 > Settings > General > Handle archives with ForkLift [true|false] ==/
    defaults_write "ForkLift" "com.binarynights.ForkLift-3" "HandleArchives" "bool" "true"

    # == Forklift 3 > Settings > General > Show ForkLift Mini in menu bar [true|false] ==/
    defaults_write "ForkLift" "com.binarynights.ForkLift-3" "ForkLiftMiniEnabled" "bool" "false"

    # == Forklift 3 > Settings > General > Set Terminal Application [0=Terminal|1=iTerm|2=Hyper|3=Kitty] ==/
    defaults_write "ForkLift" "com.binarynights.ForkLift-3" "TerminalApplication" "int" "1"

    # == Forklift 3 > Settings > General > Set Compare Application [0=File Merge|1=Kaleidoscope|2=Beyond Compare|3=Araxis Merge] ==/
    defaults_write "ForkLift" "com.binarynights.ForkLift-3" "CompareApplication" "int" "0"

    # == Forklift 3 > View > Show titlebar [true|false] ==/
    defaults_write "ForkLift" "com.binarynights.ForkLift-3" "ShowTitlebar" "bool" "true"

    # == Forklift 3 > View > Show sidebar [true|false] ==/
    defaults_write "ForkLift" "com.binarynights.ForkLift-3" "ShowSidebar" "bool" "true"

    # == Forklift 3 > View > Set tabbar [true|false] ==/
    defaults_write "ForkLift" "com.binarynights.ForkLift-3" "ShowTabbar" "bool" "false"

    # == Forklift 3 > View > Show device informations [true|false] ==/
    defaults_write "ForkLift" "com.binarynights.ForkLift-3" "SidebarShowDeviceinfo" "bool" "true"

    # == Forklift 3 > View > Show preview [true|false] ==/
    defaults_write "ForkLift" "com.binarynights.ForkLift-3" "ShowPreview" "bool" "true"

    kill_app ForkLift ForkLiftMini
}

__init__() {
    print_cat "Setting up application ForkLift 3!"
    general_setup
}

__init__
