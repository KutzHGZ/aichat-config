#!/usr/bin/env bash

# @describe Revert file changes.
# @option --path! The file path to revert
# Underlying command: `git restore`
# @env LLM_OUTPUT=/dev/stdout The output path

git_restore() {
	if git restore -- "${argc_path}" 2>/dev/null; then
		printf "**Changes restored:** %s\n" "${argc_path}" >> "${LLM_OUTPUT}"
	else
		printf "**Failed to restore:** %s\n" "${argc_path}" >> "${LLM_OUTPUT}"
	fi

	return 0
}

main() {
	git_restore "$@"
}

# See https://github.com/sigoden/argc
eval "$(argc --argc-eval "$0" "$@")"
