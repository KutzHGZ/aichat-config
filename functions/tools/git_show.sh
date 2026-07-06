#!/usr/bin/env bash

# @describe Show Git commit informations.
# @option --id Optional commit id
# Underlying command: `git show`
# @env LLM_OUTPUT=/dev/stdout The output path

git_show() {
	if [ -n "${argc_id}" ]; then
		show="$(git show "${argc_id}" 2>/dev/null)"
	else
		show="$(git show 2>/dev/null)"
	fi

	if [ -n "${show}" ]; then
		printf "**Git show:**\n%s\n" "${show}" >> "${LLM_OUTPUT}"
	else
		printf "**Git show empty.**\n" >> "${LLM_OUTPUT}"
	fi

	return 0
}

main() {
	git_show "$@"
}

# See https://github.com/sigoden/argc
eval "$(argc --argc-eval "$0" "$@")"
