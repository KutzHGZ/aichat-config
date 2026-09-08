#!/usr/bin/env bash

# @describe Apply a patch to a file at the specified path.
# This can be used to edit the file, without having to rewrite the entire file.
# @option --path! The path of the file to apply the patch to
# @option --content! The unified context diff format patch to apply
# Underlying command: `patch -f -l -p1 -F 10`
#
# Here is an example of a patch block (unified context diff format)
# that can be applied to modify the file to request the user's name:
# ```diff
# --- a/main.cpp
# +++ b/main.cpp
# \@@ -1,7 +1,11 @@
#  #include <iostream>
#  int
# -main()
# +main(int argc, char *argv[])
#  {
# -       std::cout << "Hello world!" << std::endl;
# +       if (argc > 1)
# +       {
# +               std::cout << "Hello world!" << std::endl;
# +       }
# +
#         return EXIT_SUCCESS;
#  }
# ```
#
# @env LLM_OUTPUT=/dev/stdout The output path

fs_patchfile() {
    if [ -f "${argc_path}" ]; then
		patch_cmd=(patch -f -l -p1 -F 10 -r - -i - -o - "${argc_path}")

		if ! new_content="$(printf "%s" "${argc_content}" | "${patch_cmd[@]}" 2>/dev/null && printf ".")"; then
			error_msg="$(printf "%s" "${argc_content}" | "${patch_cmd[@]}" 2>&1 >/dev/null)"

			# Print error log to the user
			>&2 printf "fs_patchfile: '%s'\n" "${error_msg}"

			# Log the error to the LLM
			printf "**Failed to apply patch:**\n%s\n" "${argc_content}" >> "${LLM_OUTPUT}"
			printf "**Error:**\n%s\n" "${error_msg}" >> "${LLM_OUTPUT}"
			return 0
		fi

		if printf "%s" "${new_content%?}" | git diff --no-index --exit-code -- "${argc_path}" -; then
			printf "**Patch applied with no modifications.**\n" >> "${LLM_OUTPUT}"
			return 0
		fi

		# Guard file modifications
		if ! "${LLM_ROOT_DIR}/utils/guard_operation.sh" "Apply changes?"; then
			# Print error log to the user
			>&2 printf "fs_patchfile: aborted by the user: '%s'\n" "${argc_path}"

			printf "**Patch operation aborted by the user.**\n" >> "${LLM_OUTPUT}"
			return 1
		fi

		printf "%s" "${new_content%?}" > "${argc_path}" 2>/dev/null

		printf "**Patch applied to:** %s\n" "${argc_path}" >> "${LLM_OUTPUT}"
	else
		printf "**Failed to apply patch to:** %s\n" "${argc_path}" >> "${LLM_OUTPUT}"
	fi

	return 0
}

main() {
	fs_patchfile "$@"
}

# See https://github.com/sigoden/argc
eval "$(argc --argc-eval "$0" "$@")"
