#!/usr/bin/env bash

# @describe Create a new directory at the specified path.
# @option --path! The path of the directory to create
# Underlying command: `mkdir -p`
# @env LLM_OUTPUT=/dev/stdout The output path

fs_mkdir() {
	# Guard if the LLM is creating directories outside of the cwd
    "${LLM_ROOT_DIR}/utils/guard_path.sh" \
		"${argc_path}" "Create directory '${argc_path}'?" || return

    if mkdir -p "${argc_path}" 2>/dev/null; then
		printf "**Directory created:** %s\n" "${argc_path}" >> "${LLM_OUTPUT}"
	else
		# Print error log to the user
		>&2 printf "fs_mkdir: unable to create directory: '%s'\n" "${argc_path}"

		printf "**Failed to create directory:** %s\n" "${argc_path}" >> "${LLM_OUTPUT}"
	fi

	return 0
}

main() {
	fs_mkdir "$@"
}

# See https://github.com/sigoden/argc
eval "$(argc --argc-eval "$0" "$@")"
