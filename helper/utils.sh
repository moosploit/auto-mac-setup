#!/bin/bash
# ================================================================================
# -- File:          helper/utils.sh
# -- Project:       auto-mac-setup
# -- Project URL:   https://github.com/moosploit/auto-mac-setup
# -- Create Date:   2020-09-01 15:45
# -- Author:        Michael Linder
# -- Company:       moosploit.com
# -- License:       MIT License | http://www.opensource.org/licenses/MIT
# ================================================================================

check_cmd_exists() {
    command -v "$1" &> /dev/null
}

get_os() {
    local os=""
    local kernelName="$(uname -s)"

    if [ "$kernelName" == "Darwin" ]; then
        os="macos"
    elif [ "$kernelName" == "Linux" ] && [ -e "/etc/os-release" ]; then
        os="$(. /etc/os-release; printf "%s" "$ID")"
    else
        os="$kernelName"
    fi

    printf "%s" "$os"
}

get_os_version() {
    local version=""
    local os="$(get_os)"

    if [ "$os" == "macos" ]; then
        version="$(sw_vers -productVersion)"
    elif [ -e "/etc/os-release" ]; then
        version="$(. /etc/os-release; printf "%s" "$VERSION_ID")"
    fi

    printf "%s" "$version"
}