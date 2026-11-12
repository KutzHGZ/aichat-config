#!/usr/bin/env bash

# @describe Execute a Python 3 script.
# @option --script! The python script
#
# Python3 script example:
# ```python
# #!/usr/bin/env python3
# print("Hello, world!")
# ```
#
# @env LLM_OUTPUT=/dev/stdout The output path

py_exec() {
	# Print the python script to the user
	if command -v "batcat" >/dev/null 2>&1; then
		printf "%s" "${argc_script}" | batcat --paging=never --style=grid --tabs=4 -l py3 -
	else
		printf "%s\n" "${argc_script}"
	fi

	# Guard execution
	if ! "${LLM_ROOT_DIR}/utils/guard_operation.sh" "Run python script?"; then
		# Print error log to the user
		>&2 printf "py_exec: aborted by the user\n"

		printf "**Python script execution aborted by the user.**\n" >> "${LLM_OUTPUT}"
		return 1
	fi

	if script_output="$(env python3 <<< "${argc_script}" 2>&1)"; then
		script_result="was successful (exit code: $?)"
	else
		script_result="failed (exit code: $?)"

		# Print error log to the user
		>&2 printf "py_exec: unable to execute python script\n"
	fi

	if [ -n "${script_output}" ]; then
		printf "**Python script %s with output:**\n%s\n" \
			   "${script_result}" "${script_output}" >> "${LLM_OUTPUT}"
	else
		printf "**Python script %s without output.**\n" \
			   "${script_result}" >> "${LLM_OUTPUT}"
	fi

	return 0
}

main() {
	py_exec "$@"
}

# See https://github.com/sigoden/argc
eval "$(argc --argc-eval "$0" "$@")"
