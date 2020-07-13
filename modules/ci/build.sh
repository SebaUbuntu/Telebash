#!/bin/bash
#
# Copyright (C) 2020 SebaUbuntu's HomeBot
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Source variables and basic functions
source variables.sh
source base/telegram_base.sh
source base/telegram_get.sh
source base/get.sh
source base/telegram_send.sh

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
		tg_send_message --chat_id "$(tg_get_chat_id "$@")" --text "CI building failed: Project not found

Usage: \`/ci <project> [arguments]\`
Arguments are project-specific, to know what arguments you can use with a project, use \`-h\` or \`--help\`." --reply_to_message_id "$(tg_get_message_id "$@")" --parse_mode "Markdown"
	fi
else
	tg_send_message --chat_id "$(tg_get_chat_id "$@")" --text "CI building failed: No projects has been defined

Usage: \`/ci <project> [arguments]\`
Arguments are project-specific, to know what arguments you can use with a project, use \`-h\` or \`--help\`." --reply_to_message_id "$(tg_get_message_id "$@")" --parse_mode "Markdown"
fi
