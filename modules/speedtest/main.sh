#!/bin/bash
#
# Copyright (C) 2021 Telebash
#
# SPDX-License-Identifier: Apache-2.0
#

module_speedtest() {
	local MESSAGE_ID=$(telegram sendMessage --chat_id "$(tg_get_chat_id "$@")" --text "Running speedtest..." --reply_to_message_id "$(tg_get_message_id "$@")" | jq .result.message_id)
	telegram editMessageText --chat_id "$(tg_get_chat_id "$@")" --message_id "$MESSAGE_ID" --text "\`$(speedtest-cli | grep "Mbit/s")\`" --parse_mode "Markdown"
}
