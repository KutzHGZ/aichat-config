#!/usr/bin/env bash

# @describe Create a new file at the specified path with an optional content.
# @option --path! The path where the file should be created
# @option --content Optional file contents
# @env LLM_OUTPUT=/dev/stdout The output path

fs_mkfile() {
	# Guard if the LLM is creating files outside of the cwd
    "${LLM_ROOT_DIR}/utils/guard_path.sh" \
		"${argc_path}" "Create file '${argc_path}'?" || return

    if mkdir -p "$(dirname "${argc_path}")" 2>/dev/null; then
		printf "%s" "${argc_content}" > "${argc_path}" 2>/dev/null
		printf "**File created:** %s\n" "${argc_path}" >> "${LLM_OUTPUT}"
	else
		# Print error log to the user
		>&2 printf "fs_mkfile: unable to create file: '%s'\n" "${argc_path}"

		printf "**Failed to create file:** %s\n" "${argc_path}" >> "${LLM_OUTPUT}"
	fi

	return 0
}

main() {
	fs_mkfile "$@"
}

# See https://github.com/sigoden/argc
eval "$(argc --argc-eval "$0" "$@")"
