#!/bin/bash
#
# Copyright (C) 2021 Telebash
#
# SPDX-License-Identifier: Apache-2.0
#

module_neofetch() {
	telegram sendMessage --chat_id "$(tg_get_chat_id "$@")" --text "\`$(neofetch --stdout)\`" --reply_to_message_id "$(tg_get_message_id "$@")" --parse_mode "Markdown"
}
