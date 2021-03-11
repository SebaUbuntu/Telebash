#!/bin/bash
#
# Copyright (C) 2021 Telebash
#
# SPDX-License-Identifier: Apache-2.0
#

module_ci() {
	for userid in $CI_APPROVED_USER_IDS; do
		if [ "$(tg_get_sender_id "$@")" = "$userid" ]; then
			local CI_AUTHORIZED=true
		fi
	done
	if [ "$CI_AUTHORIZED" = true ]; then
		if [ "$CI_CHANNEL_ID" != "" ]; then
			modules/ci/build.sh "$@" &
		else
			telegram sendMessage --chat_id "$(tg_get_chat_id "$@")" --text "Error: CI channel or user ID not defined" --reply_to_message_id "$(tg_get_message_id "$@")"
		fi
	else
		telegram sendMessage --chat_id "$(tg_get_chat_id "$@")" --text "Error: you are not authorized to use CI function of this bot, ask to who host this bot to add you to the authorized people list" --reply_to_message_id "$(tg_get_message_id "$@")"
	fi
}
