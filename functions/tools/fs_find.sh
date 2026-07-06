#!/usr/bin/env bash

# @describe Find files or directories paths, given an optional name, in all subdirectories of the given path.
# @option --path! The directory path to search
# @option --name Optional wildcard name of the directory or file to find
# @option --depth <INT> Optional maximum directory depth search level
# Underlying command: `find -maxdepth -iname -print`
# @env LLM_OUTPUT=/dev/stdout The output path

fs_find() {
	name_opt=(${argc_name:+-iname "${argc_name}"})
	depth_opt=(${argc_depth:+-maxdepth "${argc_depth}"})

	found="$(find "${argc_path}" "${depth_opt[@]}" "${name_opt[@]}" -print 2>/dev/null)"

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
