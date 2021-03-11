#!/bin/bash
#
# Copyright (C) 2021 Telebash
#
# SPDX-License-Identifier: Apache-2.0
#

module_start() {
	telegram sendMessage --chat_id "$(tg_get_chat_id "$@")" --text "Hi! I'm a multifunction bot, written in Bash by SebaUbuntu, because Python is boring
I use modules to expand my features, you can see what commands you can use by typing .modules

Version: $VERSION ($BRANCH)"
}

module_info() {
	telegram sendMessage --chat_id "$(tg_get_chat_id "$@")" --text "\`\`\`
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
	telegram sendMessage --chat_id "$(tg_get_chat_id "$@")" --text "🏃" --reply_to_message_id "$(tg_get_message_id "$@")"
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
	telegram sendMessage --chat_id "$(tg_get_chat_id "$@")" --text "$MODULE_LIST_MESSAGE" --reply_to_message_id "$(tg_get_message_id "$@")" --parse_mode "Markdown"
}

module_me() {
	local CHAT_MEMBER_INFO=$(telegram getChatMember --chat_id "$(tg_get_chat_id "$@")" --user_id "$(tg_get_sender_id "$@")")
	local ME_MESSAGE="Information about you:
Full name: $(tg_get_member_full_name "$CHAT_MEMBER_INFO")
Username: @$(tg_get_member_user_name "$CHAT_MEMBER_INFO")
User ID: \`$(tg_get_member_user_id "$CHAT_MEMBER_INFO")\`
Language: $(tg_get_member_user_language_code "$CHAT_MEMBER_INFO")
"
	telegram sendMessage --chat_id "$(tg_get_chat_id "$@")" --text "$ME_MESSAGE" --reply_to_message_id "$(tg_get_message_id "$@")" --parse_mode "Markdown"
}
