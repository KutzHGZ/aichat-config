#!/usr/bin/env bash

# @describe Read the content of a file at the specified path.
# @option --path! The path of the file to read
# @option --head <INT> Optional first number of lines to output
# @option --tail <INT> Optional last number of lines to output
# Underlying command: `cat | head | tail`
# @env LLM_OUTPUT=/dev/stdout The output path

fs_cat() {
	# Trailing new lines are stipped when capturing command outputs
	# This is not wished when manipulating file content,
	# we workaround by printing "." at the end, then remove it.
    if ! content="$(cat "${argc_path}" 2>/dev/null && printf ".")"; then
		printf "**Failed to read file content.**\n" >> "${LLM_OUTPUT}"
		return 0
	fi

	if [ -n "${argc_head}" ]; then
		content="$(printf "%s" "${content%?}" | head -n "${argc_head}" 2>/dev/null)"
	fi

	if [ -n "${argc_tail}" ]; then
		content="$(printf "%s" "${content%?}" | tail -n "${argc_tail}" 2>/dev/null)"
	fi

	printf "**File content:**\n%s\n" "${content%?}" >> "${LLM_OUTPUT}"

	return 0
}

main() {
	fs_cat "$@"
}

# See https://github.com/sigoden/argc
eval "$(argc --argc-eval "$0" "$@")"
