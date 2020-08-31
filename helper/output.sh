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

print_in_color() {
    printf "%b" "$(tput setaf "$2" 2> /dev/null)" "$1" "$(tput sgr0 2> /dev/null)"
}

# Output functions
ok() {
	printf $col_green"[OK]"$col_reset" %s \n" $1
}

cow() {
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

cat() {
	printf "\n"
	printf $col_green"(,,,)=(^.^)=(,,,)"$col_reset" - %s \n" "$1"
	printf "\n"
}

action() {
	printf $col_magenta"[action]"$col_reset" ❯ %s \n" "$1"
}

run() {
	printf $col_yellow"==❯"$col_reset" %s \n" "$1"
}

warn() {
	printf $col_yellow"[warning]"$col_reset" %s \n" "$1"
}

error() {
	printf $col_red"[error]"$col_reset" %s \n" "$1"
}

success() {
	printf $col_green" [✔]"$col_reset" %s \n" "$1"
}

fail() {
	printf $col_red" [✖]"$col_reset" %s \n" "$1"
}

result() {
	if [ "$1" -eq 0 ]; then
		success "$2"
	else
		fail "$2"
	fi
	return "$1"
}