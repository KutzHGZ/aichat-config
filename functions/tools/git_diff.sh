#!/usr/bin/env bash

# @describe Display working-tree unstaged changes as a patch block.
# @option --path Optional path to narrow the working tree
# Underlying command: `git diff`
# @env LLM_OUTPUT=/dev/stdout The output path

git_diff() {
	if [ -n "${argc_path}" ]; then
		gtdiff="$(git diff -- "${argc_path}" 2>/dev/null)"
	else
		gtdiff="$(git diff 2>/dev/null)"
	fi

	if [ -n "${gtdiff}" ]; then
		printf "**Git diff:**\n%s\n" "${gtdiff}" >> "${LLM_OUTPUT}"
	else
		printf "**Git diff empty.**" >> "${LLM_OUTPUT}"
	fi

	return 0
}

main() {
	git_diff "$@"
}

# See https://github.com/sigoden/argc
eval "$(argc --argc-eval "$0" "$@")"
