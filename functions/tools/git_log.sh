#!/usr/bin/env bash

# @describe List Git commit history.
# @option --path Optional path to narrow the history
# @option --num <INT> Optional number of commit to output
# Underlying command: `git log`
# @env LLM_OUTPUT=/dev/stdout The output path

git_log() {
	num_opt=(${argc_num:+-n "${argc_num}"})

	if [ -n "${argc_path}" ]; then
		log="$(git log --pretty=oneline "${num_opt[@]}" -- "${argc_path}" 2>/dev/null)"
	else
		log="$(git log --pretty=oneline "${num_opt[@]}" 2>/dev/null)"
	fi

	if [ -n "${log}" ]; then
		printf "**Git log:**\n%s\n" "${log}" >> "${LLM_OUTPUT}"
	else
		printf "**Git log empty.**\n" >> "${LLM_OUTPUT}"
	fi

	return 0
}

main() {
	git_log "$@"
}

# See https://github.com/sigoden/argc
eval "$(argc --argc-eval "$0" "$@")"
