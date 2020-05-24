#!/bin/bash
#
# Copyright (C) 2020 SebaUbuntu's Telegram Bash Bot
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

# Arguments: <curl arguments>
tg_get_updates() {
	curl -s -X GET "$TG_API_URL/getUpdates" $@ | jq .
}

# Arguments: <update in JSON>
tg_get_update_result() {
	echo "$@" | jq ".result"
}

# Arguments: <update in JSON>
tg_get_unread_updates() {
	tg_get_update_result "$@" | jq ".[]"
}

# Arguments: <update in JSON>
tg_get_unread_updates_number() {
	tg_get_update_result "$@" | jq "length"
}

# Arguments: <update in JSON> <offset>
tg_get_specific_update() {
	tg_get_update_result "$1" | jq ".[$2]"
}

# Arguments: <update in JSON>
tg_get_last_update_id() {
	UPDATE_NUMBER=$(tg_get_unread_updates_number "$@")
	UPDATE_NUMBER=$(( UPDATES_NUMBER - 1 ))
	tg_get_specific_update "$@" "$UPDATE_NUMBER" | jq ".update_id"
}

# Arguments: <result in JSON>
tg_get_message() {
	echo "$@" | jq ".message"
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
tg_get_sender_id() {
	tg_get_message "$@" | jq ".from.id"
}

# Arguments: <message in JSON>
tg_get_chat_id() {
	tg_get_message "$@" | jq ".chat.id"
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