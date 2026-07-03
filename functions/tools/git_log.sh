#!/usr/bin/env bash

# @describe List Git commit history.
# @option --path Optional path to narrow the history.
# Underlying command: `git log`
# @env LLM_OUTPUT=/dev/stdout The output path

git_log() {
	if [ -n "${argc_path}" ]; then
		log="$(git log -- "${argc_path}" 2>/dev/null)"
	else
		log="$(git log 2>/dev/null)"
	fi

	if [ -n "${log}" ]; then
		printf "**Git log:**\n%s\n" "${log}" >> "${LLM_OUTPUT}"
	else
		printf "**Git log empty.**" >> "${LLM_OUTPUT}"
	fi

	return 0
}

main() {
	git_log "$@"
}

# See https://github.com/sigoden/argc
eval "$(argc --argc-eval "$0" "$@")"
