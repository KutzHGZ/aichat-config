#!/usr/bin/env bash

# @describe Create a new commit.
# @option --message! The commit message
# Underlying command: `git commit -m`
#
# Here is a template of a conventional commit message:
# <type>(scope): Small one line description [optional:, #task-id]
#
# [optional: extended description of the change made]
#
# [optional: footer]
#
# @env LLM_OUTPUT=/dev/stdout The output path

git_commit() {
	if git commit -m "${argc_message}" 2>/dev/null; then
		printf "**Commit created with id:** %s\n" "$(git rev-parse HEAD)" >> "${LLM_OUTPUT}"
	else
		printf "**Failed to create commit.**\n" >> "${LLM_OUTPUT}"
	fi

	return 0
}

main() {
	git_commit "$@"
}

# See https://github.com/sigoden/argc
eval "$(argc --argc-eval "$0" "$@")"
