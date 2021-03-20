#!/bin/bash
# ============================================================================
# -- File:          PDFScanner/setup_pdfscanner.sh
# -- Project:       auto-mac-setup
# -- Project URL:   https://github.com/moosploit/auto-mac-setup
# -- Create Date:   2021-03-19 16:08
# -- Author:        moosploit
# -- License:       MIT License | http://www.opensource.org/licenses/MIT
# ============================================================================

# Check whether the script is called directly or via source
if [[ $(basename ${0}) == $(basename ${BASH_SOURCE}) ]]; then
    source ../../../helper/output.sh
    source ../../../helper/utils.sh
    source ../../../helper/global_variables.sh
    project_dir_pdfscanner="$ROOT_DIR"
else
    project_dir_pdfscanner="$ROOT_DIR/src/setup/PDFScanner"
fi

general_setup() {
    ask_for_confirmation "Should I setup PDFScanner now?"
    if ! answer_is_yes; then
        return 1
    fi

    # === PDFScanner > Settings > General > Delete Saved Pages [false|true] === /
    defaults_write "PDFScanner" "org.planbnet.pdfscanner" "deleteSavedPages" "bool" "true"

    # === PDFScanner > Settings > General > Open Files with OCR automatically [false|true] === /
    defaults_write "PDFScanner" "org.planbnet.pdfscanner" "ocrOnImport" "bool" "true"

    # === PDFScanner > Settings > Advanced > Activate Better Kompression for Colorscans [false|true] === /
    defaults_write "PDFScanner" "org.planbnet.pdfscanner" "jpeg2000" "bool" "true"

    kill_app "PDFScanner"
}

__init__() {
    print_cat "Setting up application PDFScanner!"
    general_setup
}

__init__
