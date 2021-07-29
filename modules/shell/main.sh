#!/bin/bash
#
# Copyright (C) 2021 Telebash
#
# SPDX-License-Identifier: Apache-2.0
#

module_shell() {
	if [ "$(tg_get_command_arguments "$@")" != "" ]; then
		telegram sendMessage --chat_id "$(tg_get_chat_id "$@")" --text "\`$($(tg_get_command_arguments "$@"))\`" --reply_to_message_id "$(tg_get_message_id "$@")" --parse_mode "Markdown"
	else
		telegram sendMessage --chat_id "$(tg_get_chat_id "$@")" --text "Error: please write something after the command" --reply_to_message_id "$(tg_get_message_id "$@")"
	fi

}