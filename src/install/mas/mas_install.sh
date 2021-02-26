#!/bin/bash
# ============================================================================
# -- File:          mas/mas_install.sh
# -- Project:       auto-mac-setup
# -- Project URL:   https://github.com/moosploit/auto-mac-setup
# -- Create Date:   2020-08-28 13:07
# -- Author:        moosploit
# -- License:       MIT License | http://www.opensource.org/licenses/MIT
# ============================================================================

# Check whether the script is called directly or via source
if [[ $(basename ${0}) == $(basename ${BASH_SOURCE}) ]]; then
    source ../../../helper/output.sh
    source ../../../helper/utils.sh
fi

__init__() {
    ask_for_sudo

    print_cat "Now we will install some applications from the Mac App Store (MAS)!"

    print_cat "MAS | Install some usefull 'Tools'!"
    mas_install "Amphetamine" "937984704"
    mas_install "Moom" "419330170"
    mas_install "DaisyDisk" "411643860"
    mas_install "Disk Speed Test" "425264550"
    mas_install "Unsplash Wallpapers" "1284863847"

    print_cat "MAS | Install some cool 'Development' applications!"
    mas_install "Xcode" "497799835"
    mas_install "CotEditor" "1024640650"
    mas_install "SnippetsLab" "1006087419"

    print_cat "MAS | Install some nifty 'Media Editing' applications!"
    mas_install "Affinity Designer" "824171161"
    mas_install "Affinity Photo" "824183456"
    mas_install "Affinity Publisher" "881418622"

    print_cat "MAS | Install some dusty 'Office' applications!"
    mas_install "Microsoft OneNote" "784801555"
    mas_install "GoodNotes" "1444383602"
    mas_install "Nimbus Note" "1431085284"
    mas_install "Pages" "409201541"
    mas_install "Numbers" "409203825"
    mas_install "Keynote" "409183694"
    mas_install "Spark" "1176895641"
    mas_install "Todoist" "585829637"
    mas_install "PDFScanner" "410968114"

    print_cat "MAS | Install some cool 'News' applications!"
    mas_install "News Explorer" "1032670789"
}

__init__
