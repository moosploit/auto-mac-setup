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

# Print color functions
print_in_color() {
	printf "%b" "$(tput setaf "$1" 2>/dev/null)" "$2" "$(tput sgr0 2>/dev/null)"
}

print_in_black() {
	print_in_color 0 "$1"
}

print_in_red() {
	print_in_color 1 "$1"
}

print_in_green() {
	print_in_color 2 "$1"
}

print_in_yellow() {
	print_in_color 3 "$1"
}

print_in_blue() {
	print_in_color 4 "$1"
}

print_in_magenta() {
	print_in_color 5 "$1"
}

print_in_cyan() {
	print_in_color 6 "$1"
}
print_in_white() {
	print_in_color 7 "$1"
}

# Print specific output functions
print_cow() {
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

print_cat() {
	if [[ -n "$2" ]]; then
		printf "$(print_in_cyan '\n%s %s %b\n')" " =(^.^)= " "$1" "\n          $2"
	else
		printf "$(print_in_cyan '\n%s %s\n')" " =(^.^)= " "$1"
	fi
}

print_highlight() {
	print_in_cyan "$1"
}

print_action() {
	printf "%s %s\n" "$(print_in_magenta '    ❯    ')" "$1"
}

print_run() {
	printf "%s %s\n" "$(print_in_magenta '   ==❯   ')" "$1"
}

print_question() {
	printf "%s %s\n" "$(print_in_blue '   [?]   ')" "$1"
}

print_success() {
	printf "%s %s\n" "$(print_in_green '   [✔]   ')" "$1"
}

print_warning() {
	printf "%s %s\n" "$(print_in_yellow '   [!]   ')" "$1"
}

print_fail() {
	printf "%s %s\n" "$(print_in_red '   [✖]   ')" "$1"
}

print_ok() {
	printf "%s %s\n" "$(print_in_green '[OK]     ')" "$1"
}

print_warn() {
	printf "%s %s\n" "$(print_in_yellow '[warning]')" "$1"
}

print_error() {
	printf "%s %s %s\n" "$(print_in_red '[error]  ')" "$1" "$2"
}

print_result() {
	if [ "$1" -eq 0 ]; then
		print_success "$2"
	else
		print_fail "$2" "$3"
	fi
	return "$1"
}

test_all() {
	print_cat "This is a output test string - One Line"
	print_cat "This is a output test string" "Two lines"
	print_highlight "This is a out test string - highlight"
	print_action "This is a output test string - action"
	print_run "This is a output test string - run"
	print_question "This is a output test string - question"
	print_success "This is a output test string - success"
	print_warning "This is a output test string - warning"
	print_fail "This is a output test string - fail" "ErrorCode shows here"

	print_ok "This is a output test string - ok"
	print_warn "This is a output test string - warn"
	print_error "This is a output test string - error"
	print_result $? "This is a output test string - result"
}
