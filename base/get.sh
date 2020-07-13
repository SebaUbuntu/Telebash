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
	tg_get_me | jq ".result.id"
}

# Arguments: none
tg_get_bot_name() {
	tg_get_me | jq ".result.first_name" | cut -d "\"" -f 2
}

# Arguments: none
tg_get_bot_username() {
	tg_get_me | jq ".result.username" | cut -d "\"" -f 2
}