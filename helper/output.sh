#!/bin/bash
# ================================================================================
# -- File:          helper/output.sh
# -- Project:       auto-mac-setup
# -- Project URL:   https://github.com/moosploit/auto-mac-setup
# -- Create Date:   2020-04-20 13:38
# -- Author:        Michael Linder
# -- Company:       moosploit.com
# -- License:       MIT License | http://www.opensource.org/licenses/MIT
# ================================================================================

# Define color variables
esc_seq="\033["

col_reset=$esc_seq"0;39;49m"
col_red=$esc_seq"1;31m"
col_green=$esc_seq"1;32m"
col_yellow=$esc_seq"1;33m"
col_blue=$esc_seq"1;34m"
col_magenta=$esc_seq"1;35m"
col_cyan=$esc_seq"1;36m"

# Output functions
function ok() {
	printf $col_green"[OK]"$col_reset" %s \n" $1
}

function cow() {
	printf "\n"
	printf "              (      ) \n"
	printf "              ~(^^^^)~ \n"
	printf "               ) @@ \~_          |\ \n"
	printf "              /     | \        \~ / \n"
	printf "             ( 0  0  ) \        | |       "$col_blue"Hey"$col_reset" \n"
	printf "              ---___/~  \       | |           "$col_blue"Hiya"$col_reset" \n"
	printf "               /'__/ |   ~-_____/ |                "$col_blue"Doin?"$col_reset" \n"
	printf "o          _   ~----~      ___---~ \n"
	printf "  O       //     |         | \n"
	printf "         ((~\  _|         -|                "$col_green"Let's configure your mac, shall we?"$col_reset" \n"
	printf "   o  O //-_ \/ |        ~  | \n"
	printf "        ^   \_ /         ~  | \n"
	printf "               |          ~ | \n"
	printf "               |     /     ~ | \n"
	printf "               |     (       | \n"
	printf "                \     \      /\ \n"
	printf "               / -_____-\   \ ~~-* \n"
	printf "               |  /       \  \       .==. \n"
	printf "               / /         / /       |  | \n"
	printf "             /~  |      //~  |       |__| \n"
	printf "             ~~~~        ~~~~ \n"
	printf "\n"
}

function cat() {
	# printf "\n"
	# printf "        /\_/\\ \n"
	# printf "   ____/ o o \\ \n"
	# printf " /~____  =ø= /  - "$1"\n"
	# printf "(______)__m_m)\n"
	# printf "\n"

	# printf "\n"
	# printf $col_green"=^..^= "$col_reset" - "$1"\n"
	# printf "\n"
	
	printf "\n"
	printf $col_green"(,,,)=(^.^)=(,,,)"$col_reset" - "$1"\n"
	printf "\n"
}

function action() {
	printf $col_magenta"[action]"$col_reset" ❯ %s \n" $1
}

function run() {
	printf $col_yellow"==❯"$col_reset" %s \n" $1
}

function warn() {
	printf $col_yellow"[warning]"$col_reset" %s \n" $1
}

function error() {
	printf $col_red"[error]"$col_reset" %s \n" $1
}

function fail() {
	printf $col_red"[✖]"$col_reset" %s \n" $1
}

function success() {
	printf $col_green"[✔]"$col_reset" %s \n" $1
}

function result() {
	if [ "$1" -eq 0 ]; then
		success "$2"
	else
		error "$2"
	fi
	return "$1"
}