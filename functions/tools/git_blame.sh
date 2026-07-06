#!/usr/bin/env bash

# @describe Show Git file history.
# @option --path! The path of the file.
# @option --start <INT> Optional line to start the history output
# @option --end <INT> Optional line to end the history output
# Underlying command: `git blame -L`
# @env LLM_OUTPUT=/dev/stdout The output path

git_blame() {
	if [ -n "${argc_start}" ] || [ -n "${argc_end}" ]; then
		range="${argc_start},${argc_end}"
	fi

	if [ -f "${argc_path}" ]; then
		blame="$(git blame ${range:+-L $range} -- "${argc_path}" 2>/dev/null)"
	fi

	if [ -n "${blame}" ]; then
		printf "**Git file history:**\n%s\n" "${blame}" >> "${LLM_OUTPUT}"
	else
		printf "**Git file history empty**\n" >> "${LLM_OUTPUT}"
	fi

	return 0
}

main() {
	git_blame "$@"
}

# See https://github.com/sigoden/argc
eval "$(argc --argc-eval "$0" "$@")"
