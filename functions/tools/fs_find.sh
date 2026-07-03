#!/usr/bin/env bash

# @describe Find files or directories paths, given an optional name, in all subdirectories of the given path.
# @option --path! The directory path to search
# @option --name A wildcard name of the directory or file to find
# Underlying command: `find -iname`
# @env LLM_OUTPUT=/dev/stdout The output path

fs_find() {
	if [ -n "${argc_name}" ]; then
		found="$(find "${argc_path}" -iname "${argc_name}" 2>/dev/null)"
	else
		found="$(find "${argc_path}" 2>/dev/null)"
	fi

	if [ -n "${found}" ]; then
		printf "**Files and directories found:**\n%s\n" "${found}" >> "${LLM_OUTPUT}"
	else
		printf "**No files or directories found.**\n" >> "${LLM_OUTPUT}"
	fi

	return 0
}

main() {
	fs_find "$@"
}

# See https://github.com/sigoden/argc
eval "$(argc --argc-eval "$0" "$@")"
