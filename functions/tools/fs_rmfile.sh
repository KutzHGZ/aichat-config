#!/usr/bin/env bash

# @describe Remove the file at the specified path.
# @option --path! The path of the file to remove
# Underlying command: `rm`
# @env LLM_OUTPUT=/dev/stdout The output path

fs_rmfile() {
    if [ -f "$argc_path" ]; then
		# Guard if the LLM is removing files outside of the cwd
		"${LLM_ROOT_DIR}/utils/guard_path.sh" \
			"${argc_path}" "Remove file '${argc_path}'?" || return

        if ! rm "$argc_path" 2>/dev/null; then
			# Print error log to the user
			>&2 printf "fs_rmfile: unable to remove file: '%s'\n" "${argc_path}"

			printf "**Failed to remove file:** %s\n" "${argc_path}" >> "${LLM_OUTPUT}"
		fi
    fi

	printf "**File removed:** %s\n" "${argc_path}" >> "${LLM_OUTPUT}"

	return 0
}

main() {
	fs_rmfile "$@"
}

# See https://github.com/sigoden/argc
eval "$(argc --argc-eval "$0" "$@")"
