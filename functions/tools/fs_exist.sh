#!/usr/bin/env bash

# @describe Check if a file or directory already exists at the specified path.
# @option --path! The file or directory path
# @env LLM_OUTPUT=/dev/stdout The output path

fs_exist() {
	if [ -f "${argc_path}" ]; then
		printf "**File exists:** %s\n" "${argc_path}" >> "${LLM_OUTPUT}"
	elif [ -d "${argc_path}" ]; then
		printf "**Directory exists:** %s\n" "${argc_path}" >> "${LLM_OUTPUT}"
	else
		printf "**No such file or directory exists.**\n" >> "${LLM_OUTPUT}"
	fi

	return 0
}

main() {
	fs_exist "$@"
}

# See https://github.com/sigoden/argc
eval "$(argc --argc-eval "$0" "$@")"
