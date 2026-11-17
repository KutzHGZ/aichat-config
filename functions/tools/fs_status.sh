#!/usr/bin/env bash

# @describe Display the file status (byte count, line count, permission, type) of the given path.
# @option --path! The file or directory path
# Underlying command: `wc -c; wc -l; ls -ld; file --mime`
# @env LLM_OUTPUT=/dev/stdout The output path

fs_status() {
	# Print file existence
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
		byte_count="?"
		line_count="?"

		if [ -f "${argc_path}" ] && [ -r "${argc_path}" ]; then
			byte_count="$(wc -c 2>/dev/null < "${argc_path}")"
			line_count="$(wc -l 2>/dev/null < "${argc_path}")"
		fi

		permission="$(ls -ld "${argc_path}" 2>/dev/null | awk '{print  $1}')"
		mime_type="$(file --brief --mime "${argc_path}" 2>/dev/null)"

		printf -- "- byte count: %s\n- line count: %s\n- permission: %s\n- mime type: %s\n" \
			   "${byte_count}" "${line_count}" "${permission}" "${mime_type}" >> "${LLM_OUTPUT}"
	fi

	return 0
}

main() {
	fs_status "$@"
}

# See https://github.com/sigoden/argc
eval "$(argc --argc-eval "$0" "$@")"
