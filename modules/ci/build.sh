#!/bin/bash
#
# Copyright (C) 2021 Telebash
#
# SPDX-License-Identifier: Apache-2.0
#

# Source variables and basic functions
source variables.sh
source base/telegram.sh

ci_parse_arguments() {
	while [ "${#}" -gt 0 ]; do
		case "${1}" in
			-* )
				shift
				;;
			* )
				CI_PROJECT="${1}"
				;;
		esac
		shift
	done
}

ci_parse_arguments $(tg_get_command_arguments "$@")
if [ "$CI_PROJECT" != "" ]; then
	if [ -f "modules/ci/$CI_PROJECT.sh" ]; then
		modules/ci/$CI_PROJECT.sh "$@"
	else
		telegram sendMessage --chat_id "$(tg_get_chat_id "$@")" --text "CI building failed: Project not found

Usage: \`/ci <project> [arguments]\`
Arguments are project-specific, to know what arguments you can use with a project, use \`-h\` or \`--help\`." --reply_to_message_id "$(tg_get_message_id "$@")" --parse_mode "Markdown"
	fi
else
	telegram sendMessage --chat_id "$(tg_get_chat_id "$@")" --text "CI building failed: No projects has been defined

Usage: \`/ci <project> [arguments]\`
Arguments are project-specific, to know what arguments you can use with a project, use \`-h\` or \`--help\`." --reply_to_message_id "$(tg_get_message_id "$@")" --parse_mode "Markdown"
fi
