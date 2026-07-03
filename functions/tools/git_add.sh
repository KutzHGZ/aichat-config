#!/usr/bin/env bash

# @describe Stage the file or directory for commit.
# @option --path! The path of the file or directory
# @flag --unstage Unstage the the file or directory
# Underlying command: `git add`
# @env LLM_OUTPUT=/dev/stdout The output path

git_add() {
	if git add -- "${argc_path}" 2>/dev/null; then
		printf "**Staged:** %s\n" "${argc_path}" >> "${LLM_OUTPUT}"
	else
		printf "**Failed to stage:** %s\n" "${argc_path}" >> "${LLM_OUTPUT}"
	fi

	return 0
}

git_restore_staged() {
	if git restore --staged -- "${argc_path}" 2>/dev/null; then
		printf "**Unstaged:** %s\n" "${argc_path}" >> "${LLM_OUTPUT}"
	else
		printf "**Failed to unstage:** %s\n" "${argc_path}" >> "${LLM_OUTPUT}"
	fi

	return 0
}

main() {
	if [ "${argc_unstage}" != "true" ] && [ "${argc_unstage}" != "1" ]; then
		git_add "$@"
	else
		git_restore_staged "$@"
	fi
}

# See https://github.com/sigoden/argc
eval "$(argc --argc-eval "$0" "$@")"
