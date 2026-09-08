#!/usr/bin/env bash

# @describe Append the contents at the end of the file or at the specified line number.
# This can be used to append a chunk of text, without having to rewrite the entire file.
# @option --path! The path of the file to append contents
# @option --content! The contents to append to the file
# @option --line <INT> Optional line number to append to
# @env LLM_OUTPUT=/dev/stdout The output path

fs_appendfile() {
	if [ -f "${argc_path}" ]; then
		# Guard if the LLM is creating files outside of the cwd
		"${LLM_ROOT_DIR}/utils/guard_path.sh" \
			"${argc_path}" "Append to file '${argc_path}'?" || return

		if [ -n "${argc_line}" ]; then
			orig_content="$(cat "${argc_path}" && printf ".")"

			if [ "${argc_line}" -le 1 ]; then
				(
					printf "%s" "${argc_content}"
					printf "%s" "${orig_content%?}"
				) > "${argc_path}" 2>/dev/null
			else
				(
					let "h = argc_line - 1"
					let "t = argc_line"

					printf "%s" "${orig_content%?}" | head -n "${h}"
					printf "%s" "${argc_content}"
					printf "%s" "${orig_content%?}" | tail -n "+${t}"
				) > "${argc_path}" 2>/dev/null
			fi
		else
			printf "%s" "${argc_content}" >> "${argc_path}" 2>/dev/null
		fi

		printf "**Contents appended to:** %s\n" "${argc_path}" >> "${LLM_OUTPUT}"

	else
		# Print error log to the user
		>&2 printf "fs_appendfile: unable to append content to: '%s'\n" "${argc_path}"

		printf "**Failed to append contents to:** %s\n" "${argc_path}" >> "${LLM_OUTPUT}"
	fi

	return 0
}

main() {
	fs_appendfile "$@"
}

# See https://github.com/sigoden/argc
eval "$(argc --argc-eval "$0" "$@")"
