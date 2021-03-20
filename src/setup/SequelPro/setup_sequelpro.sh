#!/bin/bash
# ============================================================================
# -- File:          SequelPro/setup_sequelpro.sh
# -- Project:       auto-mac-setup
# -- Project URL:   https://github.com/moosploit/auto-mac-setup
# -- Create Date:   2021-03-20 18:00
# -- Author:        moosploit
# -- License:       MIT License | http://www.opensource.org/licenses/MIT
# ============================================================================

# Check whether the script is called directly or via source
if [[ $(basename ${0}) == $(basename ${BASH_SOURCE}) ]]; then
    source ../../../helper/output.sh
    source ../../../helper/utils.sh
    source ../../../helper/global_variables.sh
    project_dir_istatmenus="$ROOT_DIR"
else
    project_dir_istatmenus="$ROOT_DIR/src/setup/SequelPro"
fi

general_setup() {
    ask_for_confirmation "Should I setup Sequel Pro now?"
    if ! answer_is_yes; then
        return 1
    fi

    # === Sequel Pro > Settings > General > Default Favorite === /
    defaults_write "Sequel Pro" "com.sequelpro.SequelPro" "DefaultFavorite" "int" "0"

    # === Sequel Pro > Settings > General > Default View [1=Structure|2=Content|3=Relations|4=Informations|5=Queries|6=Trigger] === /
    defaults_write "Sequel Pro" "com.sequelpro.SequelPro" "DefaultViewMode" "int" "2"

    # === Sequel Pro > Settings > General > Use Monospaced Fonts [false|true] === /
    defaults_write "Sequel Pro" "com.sequelpro.SequelPro" "UseMonospacedFonts" "bool" "true"

    # === Sequel Pro > Settings > General > Display Vertical Table Gridlines [false|true] === /
    defaults_write "Sequel Pro" "com.sequelpro.SequelPro" "DisplayTableViewVerticalGridlines" "bool" "true"

    # === Sequel Pro > Settings > General > Save Last xxx Queries === /
    defaults_write "Sequel Pro" "com.sequelpro.SequelPro" "CustomQueryMaxHistoryItems" "int" "50"

    # === Sequel Pro > Settings > Tables > xxx === /
    # defaults_write "Sequel Pro" "com.sequelpro.SequelPro" "CustomQueryMaxHistoryItems" "int" "true"

    # === Sequel Pro > Settings > Tables > Reload Tables after Removing Rows === /
    defaults_write "Sequel Pro" "com.sequelpro.SequelPro" "ReloadAfterRemovingRow" "bool" "true"

    # === Sequel Pro > Settings > Messages > Activate Messages === /
    defaults_write "Sequel Pro" "com.sequelpro.SequelPro" "GrowlEnabled" "bool" "false"

    # === Sequel Pro > Settings > Messages > Logging Import & Export === /
    defaults_write "Sequel Pro" "com.sequelpro.SequelPro" "ConsoleEnableImportExportLogging" "bool" "true"

    # === Sequel Pro > Settings > Editor > Tabs are spaces === /
    defaults_write "Sequel Pro" "com.sequelpro.SequelPro" "CustomQuerySoftIndent" "bool" "true"
    defaults_write "Sequel Pro" "com.sequelpro.SequelPro" "CustomQuerySoftIndentWidth" "int" "4"

    # === Sequel Pro > Settings > Editor > Keywords in Uppsercase [false|true] === /
    defaults_write "Sequel Pro" "com.sequelpro.SequelPro" "CustomQueryAutoUppercaseKeywords" "bool" "true"

    # === Sequel Pro > View > Display TabBar [false|true] === /
    defaults_write "Sequel Pro" "com.sequelpro.SequelPro" "WindowAlwaysShowTabBar" "bool" "false"

    # === Sequel Pro > Table Informationms Panel Collapsed [false|true] === /
    defaults_write "Sequel Pro" "com.sequelpro.SequelPro" "TableInformationPanelCollapsed" "bool" "false"

    kill_app "Sequel Pro"
}

__init__() {
    print_cat "Setting up application Sequel Pro!"
    general_setup
}

__init__
