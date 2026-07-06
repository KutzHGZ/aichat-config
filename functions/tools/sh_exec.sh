#!/usr/bin/env bash

# @describe Execute a shell command with any argument.
# @option --command! The shell command
#
# Here are examples of commands:
# - `cmake --build build -t all test`
# - `ctest`
# - `make`
# - `./main`
#
# @env LLM_OUTPUT=/dev/stdout The output path

sh_exec() {
	# Guard command execution
	if ! "${LLM_ROOT_DIR}/utils/guard_operation.sh" "Run command?"; then
		# Print error log to the user
		>&2 printf "sh_exec: aborted by the user: '%s'\n" "${argc_command}"

		printf "**Command execution aborted by the user.**\n" >> "${LLM_OUTPUT}"
		return 1
	fi

	if cmd_output="$(eval "${argc_command}" 2>&1)"; then
		cmd_result="was successful (exit code: $?)"
	else
		cmd_result="failed (exit code: $?)"

		# Print error log to the user
		>&2 printf "sh_exec: unable to execute command '%s'\n" "${argc_command}"
	fi

	if [ -n "${cmd_output}" ]; then
		printf "**Command %s with output:**\n%s\n" \
			   "${cmd_result}" "${cmd_output}" >> "${LLM_OUTPUT}"
	else
		printf "**Command %s without output.**\n" \
			   "${cmd_result}" >> "${LLM_OUTPUT}"
	fi

	return 0
}

main() {
	sh_exec "$@"
}

# See https://github.com/sigoden/argc
eval "$(argc --argc-eval "$0" "$@")"
