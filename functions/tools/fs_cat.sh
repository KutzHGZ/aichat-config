#!/usr/bin/env bash

# @describe Read the contents of a file at the specified path.
# @option --path! The path of the file to read
# Underlying command: `cat`
# @env LLM_OUTPUT=/dev/stdout The output path

fs_cat() {
    if contents="$(cat "${argc_path}" 2>/dev/null)"; then
		printf "**File contents:**\n%s\n" "${contents} ">> "${LLM_OUTPUT}"
	else
		printf "**Failed to read file contents.**\n" >> "${LLM_OUTPUT}"
	fi

	return 0
}

main() {
	fs_cat "$@"
}

# See https://github.com/sigoden/argc
eval "$(argc --argc-eval "$0" "$@")"
