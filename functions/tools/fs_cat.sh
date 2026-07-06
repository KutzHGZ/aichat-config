#!/usr/bin/env bash

# @describe Read the contents of a file at the specified path.
# @option --path! The path of the file to read
# @option --head <INT> Optional first number of lines to output
# @option --tail <INT> Optional last number of lines to output
# Underlying command: `cat | head | tail`
# @env LLM_OUTPUT=/dev/stdout The output path

fs_cat() {
    if ! contents="$(cat "${argc_path}" 2>/dev/null)"; then
		printf "**Failed to read file contents.**\n" >> "${LLM_OUTPUT}"
		return 0
	fi

	if [ -n "${argc_head}" ]; then
		contents="$(printf "%s" "${contents}" | head -n "${argc_head}" 2>/dev/null)"
	fi

	if [ -n "${argc_tail}" ]; then
		contents="$(printf "%s" "${contents}" | tail -n "${argc_tail}" 2>/dev/null)"
	fi

	printf "**File contents:**\n%s\n" "${contents}" >> "${LLM_OUTPUT}"

	return 0
}

main() {
	fs_cat "$@"
}

# See https://github.com/sigoden/argc
eval "$(argc --argc-eval "$0" "$@")"
