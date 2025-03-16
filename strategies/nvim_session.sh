#!/usr/bin/env bash

# "nvim session strategy" for tmux-resurrect

ORIGINAL_COMMAND="$1"
DIRECTORY="$2"

SESSION_DIR=$(tmux show-option -gqv "@resurrect-nvim-session-dir")
SESSION_DIR="${SESSION_DIR:-${XDG_STATE_HOME:-$HOME/.local/state}/nvim/sessions}"

encode_path() {
	echo "$1" | sed 's|/|%|g'
}

encode_path_nvim() {
	echo "$1" | sed 's|/|%%|g'
}

nvim_session_file_exists() {
	[ -e "${SESSION_DIR}/$(encode_path "$DIRECTORY").vim" ]
}

original_command_contains_session_flag() {
	[[ "$ORIGINAL_COMMAND" =~ "-S" ]]
}

main() {
	if nvim_session_file_exists; then
		echo "nvim -S \"${SESSION_DIR}/$(encode_path_nvim "$DIRECTORY").vim\""
	elif original_command_contains_session_flag; then
		echo "nvim"
	else
		echo "$ORIGINAL_COMMAND"
	fi
}

main
