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

module_start() {
	tg_send_message --chat_id "$(tg_get_chat_id "$@")" --text "Hi! I'm a multifunction bot, written in Bash by SebaUbuntu, because Python is boring
I use modules to expand my features, you can see what commands you can use by typing .modules

Version: $VERSION ($BRANCH)"
}

module_info() {
	tg_send_message --chat_id "$(tg_get_chat_id "$@")" --text "\`\`\`
SebaUbuntu's Bash bot
Version: $VERSION ($BRANCH)

-----------------------------
Status: Working fine
Bash version: $BASH_VERSION
Linux kernel version: $(uname -r)
Architecture: $(uname -m)
-----------------------------
\`\`\`" "$(tg_get_message_id "$@")" --parse_mode "Markdown"
}

module_runs() {
	tg_send_message --chat_id "$(tg_get_chat_id "$@")" --text "🏃" --reply_to_message_id "$(tg_get_message_id "$@")"
}

module_modules() {
	local MODULE_LIST_MESSAGE="Modules loaded:
"
	for module in $(ls modules/); do
		local MODULE_LIST_MESSAGE="$MODULE_LIST_MESSAGE
*${module}* \`\`\`"
		for command in $(cat modules/$module/commands.txt); do
			local MODULE_LIST_MESSAGE="$MODULE_LIST_MESSAGE $command"
		done
		local MODULE_LIST_MESSAGE="$MODULE_LIST_MESSAGE \`\`\`"
	done
	tg_send_message --chat_id "$(tg_get_chat_id "$@")" --text "$MODULE_LIST_MESSAGE" --reply_to_message_id "$(tg_get_message_id "$@")" --parse_mode "Markdown"
}

module_me() {
	local CHAT_MEMBER_INFO=$(tg_get_chat_member --chat_id "$(tg_get_chat_id "$@")" --user_id "$(tg_get_sender_id "$@")")
	local ME_MESSAGE="Information about you:
Full name: $(tg_get_member_full_name "$CHAT_MEMBER_INFO")
Username: @$(tg_get_member_user_name "$CHAT_MEMBER_INFO")
User ID: \`$(tg_get_member_user_id "$CHAT_MEMBER_INFO")\`
Language: $(tg_get_member_user_language_code "$CHAT_MEMBER_INFO")
Role: $(tg_get_member_status "$CHAT_MEMBER_INFO")
"
	tg_send_message --chat_id "$(tg_get_chat_id "$@")" --text "$ME_MESSAGE" --reply_to_message_id "$(tg_get_message_id "$@")" --parse_mode "Markdown"
}