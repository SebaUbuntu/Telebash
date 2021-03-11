#!/bin/bash
#
# Copyright (C) 2021 Telebash
#
# SPDX-License-Identifier: Apache-2.0
#

# Arguments: <result in JSON>
tg_get_message() {
	if [ "$(echo "$@" | jq ".message")" != "null" ]; then
		echo "$@" | jq ".message"
	elif [ "$(echo "$@" | jq ".channel_post")" != "null" ]; then
		echo "$@" | jq ".channel_post"
	else
		echo "null"
	fi
}

# Arguments: <message in JSON>
tg_get_reply_to_message() {
	tg_get_message "$@" | jq "{message: .reply_to_message}"
}

# Arguments: <message in JSON>
tg_get_message_id() {
	tg_get_message "$@" | jq ".message_id"
}

# Arguments: <message in JSON>
tg_get_message_date() {
	tg_get_message "$@" | jq ".date"
}

# Arguments: <message in JSON>
tg_get_sender_id() {
	tg_get_message "$@" | jq ".from.id"
}

# Arguments: <message in JSON>
tg_get_chat_id() {
	tg_get_message "$@" | jq ".chat.id"
}

# Arguments: <message in JSON>
tg_get_chat_title() {
	tg_get_message "$@" | jq ".chat.title"
}

# Arguments: <message in JSON>
tg_get_chat_username() {
	tg_get_message "$@" | jq ".chat.username"
}

# Arguments: <message in JSON>
tg_get_chat_type() {
	tg_get_message "$@" | jq ".chat.type"
}

# Arguments: <message in JSON>
tg_get_message_text() {
	tg_get_message "$@" | jq ".text" | cut -d "\"" -f 2
}

# Arguments: <message in JSON>
tg_get_command_arguments() {
	if [ "$(tg_get_message_text "$@" | cut -d' ' -f2-)" = "$(tg_get_message_text "$@")" ]; then
		echo ""
	else
		tg_get_message_text "$@" | cut -d' ' -f2-
	fi
}

# Arguments: <member_info>
tg_get_member_first_name() {
	echo "$@" | jq ".result.user.first_name" | cut -d "\"" -f 2
}

# Arguments: <member_info>
tg_get_member_last_name() {
	echo "$@" | jq ".result.user.last_name" | cut -d "\"" -f 2
}

# Arguments: <member_info>
tg_get_member_full_name() {
	echo "$(tg_get_member_first_name "$@") $(tg_get_member_last_name "$@")"
}

# Arguments: <member_info>
tg_get_member_user_name() {
	echo "$@" | jq ".result.user.username" | cut -d "\"" -f 2
}

# Arguments: <member_info>
tg_get_member_user_id() {
	echo "$@" | jq ".result.user.id"
}

# Arguments: <member_info>
tg_get_member_user_language_code() {
	echo "$@" | jq ".result.user.language_code" | cut -d "\"" -f 2
}

# Arguments: none
tg_get_bot_user_id() {
	telegram getMe | jq ".result.id"
}

# Arguments: none
tg_get_bot_name() {
	telegram getMe | jq ".result.first_name" | cut -d "\"" -f 2
}

# Arguments: none
tg_get_bot_username() {
	telegram getMe | jq ".result.username" | cut -d "\"" -f 2
}
