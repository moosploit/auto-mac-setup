#!/bin/bash
# ============================================================================
# -- File:          helper/utils.sh
# -- Project:       auto-mac-setup
# -- Project URL:   https://github.com/moosploit/auto-mac-setup
# -- Create Date:   2020-09-01 15:45
# -- Author:        moosploit
# -- License:       MIT License | http://www.opensource.org/licenses/MIT
# ============================================================================

# Check whether the script is called directly or via source
if [[ $(basename ${0}) == $(basename ${BASH_SOURCE}) ]]; then
    source ./output.sh
    source ./global_variables.sh
fi

# === Check Functions === /
check_cmd_exists() {
    command -v "$1" &>/dev/null
}

check_already_sudo() {
    sudo -n true 2>/dev/null
}

# === Question Handling Functions === /
ask_for_sudo() {
    if ! check_already_sudo; then
        print_cat "May i have your password please?"

        sudo -v

        # https://gist.github.com/cowboy/3118588
        while true; do
            sudo -n true
            sleep 60
            kill -0 "$$" || exit
        done &>/dev/null &
    else
        print_cat "You have already sudo privileges!"
    fi
}

ask_for_input() {
    print_question "$1"
    read -r -p "          "
}

ask_for_confirmation() {
    print_question "$1 (y|N) "
    read -r -p "          "
}

answer_is_yes() {
    [[ "$REPLY" =~ ^([yY][eE][sS]|[yY])$ ]] && return 0 || return 1
}

# === Operating System Functions === /
get_os() {
    local os=""
    local kernelName="$(uname -s)"

    if [ "$kernelName" == "Darwin" ]; then
        os="macos"
    elif [ "$kernelName" == "Linux" ] && [ -e "/etc/os-release" ]; then
        os="$(
            . /etc/os-release
            printf "%s" "$ID"
        )"
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
        version="$(
            . /etc/os-release
            printf "%s" "$VERSION_ID"
        )"
    fi

    printf "%s" "$version"
}

kill_app() {
    declare -r applications="$@"

    for application in $applications; do
        application_highlight=$(print_highlight $application)

        print_run "Killing the application $application_highlight!"
        killall "$application" &>/dev/null
        print_result "$?" "Application $application_highlight killed!"
    done
    sleep 2
}

copy_it_to() {
    declare -r module_name_highlight=$(print_highlight "$1")
    declare -r copy_name_highlight=$(print_highlight "$2")
    declare -r copy_source="$3"
    declare -r copy_target="$4"
    declare -r copy_target_highlight=$(print_highlight "$copy_target")

    if [[ "$#" -lt 4 ]]; then
        print_fail "There are not enough arguments specified for 'copy_it_to'! "
        return 1
    fi

    print_run "$module_name_highlight | Copying $copy_name_highlight to $copy_target_highlight!"
    if [[ -d "$copy_source" ]]; then
        cp -fR "$copy_source" "$copy_target" &>/dev/null
    else
        cp -f "$copy_source" "$copy_target" &>/dev/null
    fi
    print_result "$?" "$module_name_highlight | Copyied $copy_name_highlight to $copy_target_highlight!"
}

create_symlink() {
    declare -r module_name_highlight=$(print_highlight "$1")
    declare -r symlink_name_highlight=$(print_highlight "$2")
    declare -r symlink_source="$3"
    declare -r symlink_source_highlight=$(print_highlight "$symlink_source")
    declare -r symlink_target="$4"

    if [[ "$#" -lt 4 ]]; then
        print_fail "There are not enough arguments specified for 'create_symlink'! "
        return 1
    fi

    if [[ ! -e "$symlink_source" ]]; then
        print_fail "$module_name_highlight | Symlink can't be created, because source $symlink_source_highlight doesn't exist!"
        return 2
    fi

    if [[ -d "$symlink_target" ]]; then
        rm -r "$symlink_target"
    fi

    print_run "$module_name_highlight | Creating symlink for $symlink_name_highlight!"
    ln -sfn "$symlink_source" "$symlink_target" &>/dev/null
    print_result "$?" "$module_name_highlight | Symlink $symlink_name_highlight created!"
}

# === User Details Functions === /
get_username() {
    echo $(id -un) # whomai
}

get_full_username() {
    osascript -e "long user name of (system info)"
}

# === Ruby Wrapper Functions === /
ruby_install() {
    declare -r ruby_formula_name_highlight=$(print_highlight "$1")
    declare -r ruby_formula="$2"
    declare -r module_name_highlight=$(print_highlight "Ruby-Install")

    if [[ "$#" -lt 2 ]]; then
        print_fail "There are not enough arguments specified for 'ruby_install'! "
        return 1
    fi

    # == Check if ruby formula already installed == /
    gem list "$ruby_formula" &>/dev/null
    if [[ "$?" -eq 0 ]]; then
        print_success "$module_name_highlight | Formula $ruby_formula_name_highlight is already installed!"
        return 2
    fi

    # == Install ruby formula == /
    print_run "$module_name_highlight | Installing formula $ruby_formula_name_highlight!"
    sudo gem install "$ruby_formula" &>/dev/null
    print_result "$?" "$module_name_highlight | Installation of formula $ruby_formula_name_highlight"
}

# === macOS Defaults Wrapper Functions === /
defaults_write() {
    declare -r domain_name_highlight=$(print_highlight "$1")
    declare -r domain_name="$2"
    declare -r key_name="$3"
    declare -r key_name_highlight=$(print_highlight "$key_name")
    declare -r type="$4"

    local value="$5"
    local value_highlight=$(print_highlight "$value")

    # == Check if enough arguments specified == /
    if [[ "$#" -lt 4 ]]; then
        print_fail "There are not enough arguments specified for 'defaults_write'! "
        return 1
    fi

    case "$type" in
    # == If type is string, int, integer or float == /
    string | int | integer | float)
        # == Checks whether the key exists or the sent value is already set
        if [[ $(defaults read "$domain_name" "$key_name" 2>/dev/null) == "$value" ]]; then
            print_success "$domain_name_highlight | The setting $key_name_highlight is already set to $value_highlight!"
            return 2
        fi
        ;;
    # == If type is bool or boolean == /
    bool | boolean)
        case "$value" in
        # == If value is true or 1 == /
        true | 1)
            value="true"
            value_highlight=$(print_highlight "$value")
            # == Checks whether the key exists or the sent value is already set
            if [[ $(defaults read "$domain_name" "$key_name" 2>/dev/null) == "1" ]]; then
                print_success "$domain_name_highlight | The setting $key_name_highlight is already set to $value_highlight!"
                return 2
            fi
            ;;
        # == If value is false or 0 == /
        false | 0)
            value="false"
            value_highlight=$(print_highlight "$value")
            # == Checks whether the key exists or the sent value is already set
            if [[ $(defaults read "$domain_name" "$key_name" 2>/dev/null) == "0" ]]; then
                print_success "$domain_name_highlight | The setting $key_name_highlight is already set to $value_highlight!"
                return 2
            fi
            ;;
        esac
        ;;
    array | array-add) ;;

    # == If another type was sent
    *)
        print_error "Defaults | Type '$type' is in function 'defaults_write' not allowed!"
        return 99
        ;;
    esac

    print_run "$domain_name_highlight | Will set $key_name_highlight to $value_highlight!"
    if [[ -z "$value" ]]; then
        defaults write "$domain_name" "$key_name" "-$type" &>/dev/null
    else
        defaults write "$domain_name" "$key_name" "-$type" "$value" #&>/dev/null
    fi
    print_result "$?" "$domain_name_highlight | Set up $key_name_highlight to $value_highlight!"
}

add_app_to_dock() {
    declare -r dock_side="$1"
    declare -r dock_side_highlight=$(print_highlight "$dock_side")
    declare -r application="$2"
    declare -r application_highlight=$(print_highlight "$application")
    declare -r system="$3"
    declare -r module_name_highlight=$(print_highlight "Apple Dock")

    local key_name=""
    local application_array=""

    # == Check if enough arguments specified == /
    if [[ "$#" -lt 2 ]]; then
        print_fail "There are not enough arguments specified for 'add_app_to_dock'! "
        return 1
    fi

    # == On which side of the Dock should the application be placed
    case $dock_side in
    left)
        key_name="persistent-apps"
        ;;
    right)
        key_name="persistent-others"
        ;;
    esac

    # == If the application is a spacer
    if [[ "$application" =~ ^[sS](pacer|eperator) ]]; then
        application_array="<dict><key>tile-data</key><dict></dict><key>tile-type</key><string>spacer-tile</string></dict>"
    # == If the application is not a spacer
    else
        # == If the application is a apple default application
        if [[ -n "$system" ]]; then
            application_array="<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>System/Applications/$application.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
        # == If the application is a normal application
        else
            application_array="<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/$application.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
        fi
    fi

    print_run "$module_name_highlight | Adding application $application_highlight to the $dock_side_highlight!"
    defaults write com.apple.dock "$key_name" -array-add "$application_array" &>/dev/null
    print_result "$?" "$module_name_highlight | Added application $application_highlight to the $dock_side_highlight!"
    sleep 1
}

wipe_apps_from_dock() {
    declare -r dock_side="$1"
    declare -r dock_side_highlight=$(print_highlight "$dock_side")
    declare -r module_name_highlight=$(print_highlight "Apple Dock")

    local key_name=""

    # == On which side of the Dock should the application be wiped
    case $dock_side in
    left)
        key_name="persistent-apps"
        ;;
    right)
        key_name="persistent-others"
        ;;
    esac

    print_run "$module_name_highlight | Wiping all applications from the $dock_side_highlight!"
    defaults write com.apple.dock "$key_name" -array &>/dev/null
    print_result "$?" "$module_name_highlight | Wiped all applications from the $dock_side_highlight!"
    sleep 1
}

# === macOS Scutil Wrapper Functions === /
scutil_get() {
    declare -r preference=$1

    # == Check if enough arguments specified == /
    if [[ "$#" -lt 1 ]]; then
        print_fail "There are not enough arguments specified for 'scutil_get'!"
        return 1
    fi

    sudo scutil --get $preference 2>/dev/null
}

scutil_set() {
    declare -r preference=$1
    declare -r preference_highlight=$(print_highlight "$preference")
    declare -r value=$2
    declare -r value_highlight=$(print_highlight "$value")
    declare -r module_name_highlight=$(print_highlight "Scutil-Set")

    # == Check if enough arguments specified == /
    if [[ "$#" -lt 2 ]]; then
        print_fail "There are not enough arguments specified for 'scutil_set'!"
        return 1
    fi

    if [[ $(scutil_get "$preference") == "$value" ]]; then
        print_success "$module_name_highlight | Setting $preference_highlight is already set to $value_highlight!"
        return 2
    fi

    print_run "$module_name_highlight | Setting $preference_highlight to $value_highlight!"
    sudo scutil --set $preference $value &>/dev/null
    print_result "$?" "$module_name_highlight | Set $preference_highlight to $value_highlight!"
}

# === macOS Plist Wrapper Functions === /
plist_export() {
    declare -r module_name_highlight=$(print_highlight "$1")
    declare -r plist_file="$2"
    declare -r plist_file_highlight=$(print_highlight "$plist_file")
    declare -r domain_name="$3"
    declare -r domain_name_highlight=$(print_highlight "$domain_name")

    if [[ "$#" -lt 3 ]]; then
        print_fail "There are not enough arguments specified for 'plist_export'! "
        return 1
    fi

    if [[ -e "$plist_file" ]]; then
        ask_for_confirmation "File already exists, should I override it?"
        if [[ ! answer_is_yes ]]; then
            return 2
        fi
    fi
    print_run "$module_name_highlight | Exporting domain $domain_name_highlight into $plist_file_highlight!"
    defaults export "$domain_name" "$plist_file"
    print_result "$?" "$module_name_highlight | Exported domain $domain_name_highlight into $plist_file_highlight!"
}

plist_import() {
    declare -r module_name_highlight=$(print_highlight "$1") # == Module Name
    declare -r plist_file="$2"                               # == Absolute path to plist file
    declare -r plist_file_highlight=$(print_highlight "$plist_file")
    declare -r domain_name="$3" # == Domain name which should be exported
    declare -r domain_name_highlight=$(print_highlight "$domain_name")

    if [[ "$#" -lt 3 ]]; then
        print_fail "There are not enough arguments specified for 'plist_import'! "
        return 1
    fi

    if [[ ! -e "$plist_file" ]]; then
        print_fail "$module_name_highlight | Plist file $plist_file_highlight doesn't exist!"
        return 2
    fi
    print_run "$module_name_highlight | Importing Plist file $plist_file_highlight into domain $domain_name_highlight!"
    defaults import "$domain_name" "$plist_file"
    print_result "$?" "$module_name_highlight | Imported Plist file $plist_file_highlight into domain $domain_name_highlight!"
}

plist_get_property() {
    declare -r plist_property="$1" # == : seperated path to property
    declare -r plist_file="$2"

    # == Check if enough arguments specified == /
    if [[ "$#" -lt 2 ]]; then
        print_fail "There are not enough arguments specified for 'plist_get_property'! "
        return 1
    fi

    /usr/libexec/PlistBuddy -c "Print :$plist_property" "$plist_file" 2>/dev/null
}

plist_set_property() {
    declare -r module_name_highlight=$(print_highlight "$1")
    declare -r plist_property=$2 # == Path to property seperated by :
    declare -r plist_property_highlight=$(print_highlight "$plist_property")
    declare -r value=$3
    declare -r value_highlight=$(print_highlight "$value")
    declare -r plist_file=$4

    # == Check if enough arguments specified == /
    if [[ "$#" -lt 4 ]]; then
        print_fail "There are not enough arguments specified for 'plist_set_property'! "
        return 1
    fi

    if [[ $(plist_get_property "$plist_property" "$plist_file") == "$value" ]]; then
        print_success "$module_name_highlight | Setting $plist_property_highlight is already set to $value_highlight!"
        return 2
    fi

    print_run "$module_name_highlight | Setting $plist_property_highlight to $value_highlight!"
    /usr/libexec/PlistBuddy -c "Set :$plist_property $value" "$plist_file" &>/dev/null
    print_result "$?" "$module_name_highlight | Set $plist_property_highlight to $value_highlight!"
}
