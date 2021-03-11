#!/bin/bash
#
# Copyright (C) 2021 Telebash
#
# SPDX-License-Identifier: Apache-2.0
#

module_dice() {
	telegram sendDice --chat_id "$(tg_get_chat_id "$@")" --emoji "🎲" --reply_to_message_id "$(tg_get_message_id "$@")"
}

module_dart() {
	telegram sendDice --chat_id "$(tg_get_chat_id "$@")" --emoji "🎯" --reply_to_message_id "$(tg_get_message_id "$@")"
}

module_basket() {
	telegram sendDice --chat_id "$(tg_get_chat_id "$@")" --emoji "🏀" --reply_to_message_id "$(tg_get_message_id "$@")"
}

module_football() {
	telegram sendDice --chat_id "$(tg_get_chat_id "$@")" --emoji "⚽️" --reply_to_message_id "$(tg_get_message_id "$@")"
}
