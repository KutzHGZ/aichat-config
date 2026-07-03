#!/usr/bin/env bash

# @describe Remove the directory at the specified path.
# @option --path! The path of the directory to remove
# Underlying command: `rmdir`
# @env LLM_OUTPUT=/dev/stdout The output path

fs_rmdir() {
    if [ -d "${argc_path}" ]; then
		# Guard if the LLM is removing directories outside of the cwd
        "${LLM_ROOT_DIR}/utils/guard_path.sh" \
			"${argc_path}" "Remove directory '${argc_path}'?" || return

        if ! rmdir "${argc_path}" 2>/dev/null; then
			# Print error log to the user
			>&2 printf "fs_rmdir: unable to remove directory: '%s'\n" "${argc_path}"

			printf "**Failed to remove directory:** %s\n" "${argc_path}" >> "${LLM_OUTPUT}"

			return 0
		fi
    fi

	printf "**Directory removed:** %s\n" "${argc_path}" >> "${LLM_OUTPUT}"

	return 0
}

main() {
	fs_rmdir "$@"
}

# See https://github.com/sigoden/argc
eval "$(argc --argc-eval "$0" "$@")"
