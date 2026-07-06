#!/usr/bin/env bash

# @describe Initialize a new Git repository.
# @option --path! New Git repository location.
# Underlying command: `git init`
# @env LLM_OUTPUT=/dev/stdout The output path

git_init() {
	if git init "${argc_path}" 2>/dev/null; then
		printf "**Git repository created:** %s\n" "${argc_path}" >> "${LLM_OUTPUT}"
	else
		# Print error log to the usr
		>&2 printf "git_init: unable to create repository: '%s'\n" "${argc_path}"

		printf "**Failed to create Git repository.**\n" >> "${LLM_OUTPUT}"
	fi

	return 0
}

main() {
	git_init "$@"
}

# See https://github.com/sigoden/argc
eval "$(argc --argc-eval "$0" "$@")"
