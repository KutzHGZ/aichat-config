#!/usr/bin/env bash

# @describe List all files and directories in the specified directory path.
# @option --path! The path of the directory to list
# Underlying command: `ls -A1`
# @env LLM_OUTPUT=/dev/stdout The output path

fs_ls() {
    list="$(ls -A1 "${argc_path}" 2>/dev/null)"

	if [ -n "${list}" ]; then
		printf "**List of files and directories:**\n%s\n" "${list}" >> "${LLM_OUTPUT}"
	else
		printf "**No files or directories.**\n" >> "${LLM_OUTPUT}"
	fi

	return 0;
}

main() {
	fs_ls "$@"
}

# See https://github.com/sigoden/argc
eval "$(argc --argc-eval "$0" "$@")"
