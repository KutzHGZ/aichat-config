#!/usr/bin/env bash

# @describe Open and display a file with the configured editor (Emacs by default).
# @option --path! The path of the file to open
# @option --line <INT> Optional line number where the file should be opened
# Underlying command: `${EDITOR}`
# @env LLM_OUTPUT=/dev/stdout The output path

usr_editor() {
	# Default editor set in the environment
	editor="${EDITOR}"

	# Fall back to Emacs if not set (personal choice)
	if [ -z "${editor}" ]; then
		editor="emacs"
	fi

	# Check if the editor is available
	if ! command -v "${editor}" >/dev/null 2>&1; then
		# Print error log to the user
		>&2 printf "usr_editor: no editor set or available\n"

		printf "**No editor available.**\n" >> "${LLM_OUTPUT}"
		return 0
	fi

	cmd=("${editor}")

	# Emacs specific options
	if [ "${editor:0:5}" = "emacs" ] && [ -n "${argc_line}" ]; then
		# Open file at the specified line
		cmd+=("+${argc_line}:0")
	fi

	cmd+=(-- "${argc_path}")

	"${cmd[@]}" >/dev/null 2>&1 &

	printf "**Editor opened file:** '%s'\n" "${argc_path}" >> "${LLM_OUTPUT}"

	return 0
}

main() {
	usr_editor "$@"
}

# See https://github.com/sigoden/argc
eval "$(argc --argc-eval "$0" "$@")"
