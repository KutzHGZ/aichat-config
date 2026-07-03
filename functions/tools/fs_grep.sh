#!/usr/bin/env bash

# @describe Search the pattern in the file contents or recursively in the directory.
# @option --path! The path of the file or directory
# @option --pattern! Grep command basic regular expresssions (BREs)
# Underlying command: `grep -I -i`
# @env LLM_OUTPUT=/dev/stdout The output path

fs_grep() {
	if [ -d "${argc_path}" ]; then
		match="$(grep -I -i -e "${argc_pattern}" -r "${argc_path}" 2>/dev/null)"
	elif [ -f "${argc_path}" ]; then
		match="$(grep -I -i -e "${argc_pattern}" "${argc_path}" 2>/dev/null)"
	fi

	if [ -n "${match}" ]; then
		printf "**Pattern found in:**\n%s\n" "${match}" >> "${LLM_OUTPUT}"
	else
		printf "**Pattern not found.**\n" >> "${LLM_OUTPUT}"
	fi

	return 0
}

main() {
	fs_grep "$@"
}

# See https://github.com/sigoden/argc
eval "$(argc --argc-eval "$0" "$@")"
