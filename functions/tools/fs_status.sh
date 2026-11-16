#!/usr/bin/env bash

# @describe Display the file (regular, directory, block, character, ..) existance and status of the given path.
# @option --path! The file or directory path
# @env LLM_OUTPUT=/dev/stdout The output path

fs_status() {
	# Print file existance
	if [ -f "${argc_path}" ]; then
		printf "**Regular file exists:** %s\n" "${argc_path}" >> "${LLM_OUTPUT}"
	elif [ -d "${argc_path}" ]; then
		printf "**Directory exists:** %s\n" "${argc_path}" >> "${LLM_OUTPUT}"
	elif [ -e "${argc_path}" ]; then
		printf "**File exists:** %s\n" "${argc_path}" >> "${LLM_OUTPUT}"
	else
		printf "**No such file or directory exists.**\n" >> "${LLM_OUTPUT}"
	fi

	# Print file information
	if [ -e "${argc_path}" ]; then
		if [ -r "${argc_path}" ]; then
			byte_size="$(wc -c < "${argc_path}" 2>/dev/null)"
		else
			byte_size="?"
		fi

		mime_type="$(file --brief --mime "${argc_path}" 2>/dev/null)"

		printf -- "- byte count: %s\n- mime type: %s\n" "${byte_size}" "${mime_type}" >> "${LLM_OUTPUT}"
	fi

	return 0
}

main() {
	fs_status "$@"
}

# See https://github.com/sigoden/argc
eval "$(argc --argc-eval "$0" "$@")"
