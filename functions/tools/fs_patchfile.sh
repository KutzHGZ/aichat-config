#!/usr/bin/env bash

# @describe Apply a patch to a file at the specified path.
# This can be used to edit the file, without having to rewrite the entire file.
# @option --path! The path of the file to apply the patch
# @option --content! The patch to apply to the file
#
# Here is an example of a patch block that can be applied to modify the file to request the user's name:
# --- a/main.cpp
# +++ b/main.cpp
# \@@ -1,8 +1,12 @@
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
#
# @env LLM_OUTPUT=/dev/stdout The output path

fs_patchfile() {
    if [ -f "${argc_path}" ]; then
		if ! new_content="$(awk -f "${LLM_ROOT_DIR}/utils/patch.awk" "${argc_path}" <(printf "%s" "${argc_content}"))"; then
			printf "**Invalid patch format.**\n" >> "${LLM_OUTPUT}"
			return 0
		fi

		printf "%s" "${new_content}" | git diff --no-index "${argc_path}" - || true

		# Guard file modifications
		if ! "${LLM_ROOT_DIR}/utils/guard_operation.sh" "Apply changes?"; then
			# Print error log to the user
			>&2 printf "fs_patchfile: aborted by the user: '%s'\n" "${argc_path}"

			printf "**Patch operation aborted by the user.**\n" >> "${LLM_OUTPUT}"
			return 1
		fi

		printf "%s" "${new_content}" > "${argc_path}" 2>/dev/null

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
