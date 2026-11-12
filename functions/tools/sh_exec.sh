#!/usr/bin/env bash

# @describe Execute a Bash shell script.
# @option --script! The shell script
#
# Bash shell script example:
# ```sh
# #!/usr/bin/env bash
# cmake --build build -t all test
# make && ctest
# ```
#
# @env LLM_OUTPUT=/dev/stdout The output path

sh_exec() {
	# Print the schell script to the user
	if command -v "batcat" >/dev/null 2>&1; then
		printf "%s" "${argc_script}" | batcat --paging=never --style=grid --tabs=4 -l sh -
	else
		printf "%s\n" "${argc_script}"
	fi

	# Guard execution
	if ! "${LLM_ROOT_DIR}/utils/guard_operation.sh" "Run shell script?"; then
		# Print error log to the user
		>&2 printf "sh_exec: aborted by the user\n"

		printf "**Shell script execution aborted by the user.**\n" >> "${LLM_OUTPUT}"
		return 1
	fi

	if script_output="$(env bash -s <<< "${argc_script}" 2>&1)"; then
		script_result="was successful (exit code: $?)"
	else
		script_result="failed (exit code: $?)"

		# Print error log to the user
		>&2 printf "sh_exec: unable to execute shell script\n"
	fi

	if [ -n "${script_output}" ]; then
		printf "**Shell script %s with output:**\n%s\n" \
			   "${script_result}" "${script_output}" >> "${LLM_OUTPUT}"
	else
		printf "**Shell script %s without output.**\n" \
			   "${script_result}" >> "${LLM_OUTPUT}"
	fi

	return 0
}

main() {
	sh_exec "$@"
}

# See https://github.com/sigoden/argc
eval "$(argc --argc-eval "$0" "$@")"
