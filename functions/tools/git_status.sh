#!/usr/bin/env bash

# @describe Display working-tree file statuses from `HEAD`.
# @option --path Optional path to narrow the working tree
# Underlying command: `git status -s`
# @env LLM_OUTPUT=/dev/stdout The output path

git_status() {
	if [ -n "${argc_path}" ]; then
		status="$(git status -s -- "${argc_path}" 2>/dev/null)"
	else
		status="$(git status -s 2>/dev/null)"
	fi

	if [ -n "${status}" ]; then
		printf "**Git status:**\n%s\n" "${status}" >> "${LLM_OUTPUT}"
	else
		printf "**Git status empty.**\n" >> "${LLM_OUTPUT}"
	fi
}

main() {
	git_status "$@"
}

# See https://github.com/sigoden/argc
eval "$(argc --argc-eval "$0" "$@")"
