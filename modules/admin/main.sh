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

module_ban() {
	if [ "$(tg_member_can_restrict_members "$(tg_get_chat_id "$@")" "$(tg_get_sender_id "$@")")" = true ]; then
		if [ "$(tg_get_sender_id "$(tg_get_reply_to_message "$@")")" != "null" ]; then
			local USER_ID=$(tg_get_sender_id "$(tg_get_reply_to_message "$@")")
		elif [ "$(tg_get_command_arguments "$@")" != "" ]; then
			if echo "$(tg_get_command_arguments "$@")" | grep -q "@"; then
				tg_send_message "$(tg_get_chat_id "$@")" "Banning through username is not supported, reply to a message or provide a user id" "$(tg_get_message_id "$@")"
			else
				local USER_ID=$(tg_get_command_arguments "$@")
			fi
		else
			tg_send_message "$(tg_get_chat_id "$@")" "Please reply to a message or write the user id to ban that user" "$(tg_get_message_id "$@")"
		fi
		if [ "$USER_ID" != "" ]; then
			if [ "$USER_ID" = "$(tg_get_bot_user_id)" ]; then
				tg_send_message "$(tg_get_chat_id "$@")" "Why would I ban myself?" "$(tg_get_message_id "$@")"
				local USER_ID=""
			else
				local RESULT=$(tg_ban_user "$(tg_get_chat_id "$@")" "$USER_ID")
			fi
		fi
		if [ "$RESULT" != "" ]; then
			if [ "$(echo $RESULT | jq .ok)" = "true" ]; then
				tg_send_message "$(tg_get_chat_id "$@")" "$USER_ID banned successfully" "$(tg_get_message_id "$@")"
			elif [ "$(echo $RESULT | jq .description | cut -d "\"" -f 2)" = "Bad Request: user is an administrator of the chat" ]; then
				tg_send_message "$(tg_get_chat_id "$@")" "I can't ban this member, because it's an admin!" "$(tg_get_message_id "$@")"
			elif [ "$(echo $RESULT | jq .description | cut -d "\"" -f 2)" = "Bad Request: USER_ID_INVALID" ]; then
				tg_send_message "$(tg_get_chat_id "$@")" "Invalid user ID!" "$(tg_get_message_id "$@")"
			else
				echo $RESULT | jq .description | cut -d "\"" -f 2
				tg_send_message "$(tg_get_chat_id "$@")" "Unknown error!" "$(tg_get_message_id "$@")"
			fi
		fi
	fi
}

module_unban() {
	if [ "$(tg_member_can_restrict_members "$(tg_get_chat_id "$@")" "$(tg_get_sender_id "$@")")" = true ]; then
		if [ "$(tg_get_sender_id "$(tg_get_reply_to_message "$@")")" != "null" ]; then
			local USER_ID=$(tg_get_sender_id "$(tg_get_reply_to_message "$@")")
		elif [ "$(tg_get_command_arguments "$@")" != "" ]; then
			if echo "$(tg_get_command_arguments "$@")" | grep -q "@"; then
				tg_send_message "$(tg_get_chat_id "$@")" "Unbanning through username is not supported, reply to a message or provide a user id" "$(tg_get_message_id "$@")"
			else
				local USER_ID=$(tg_get_command_arguments "$@")
			fi
		else
			tg_send_message "$(tg_get_chat_id "$@")" "Please reply to a message or write the user id to unban that user" "$(tg_get_message_id "$@")"
		fi
		if [ "$USER_ID" != "" ]; then
			if [ "$USER_ID" = "$(tg_get_bot_user_id)" ]; then
				tg_send_message "$(tg_get_chat_id "$@")" "Why would I unban myself?" "$(tg_get_message_id "$@")"
				local USER_ID=""
			else
				local RESULT=$(tg_unban_user "$(tg_get_chat_id "$@")" "$USER_ID")
			fi
		fi
		if [ "$RESULT" != "" ]; then
			if [ "$(echo $RESULT | jq .ok)" = "true" ]; then
				tg_send_message "$(tg_get_chat_id "$@")" "$USER_ID unbanned successfully" "$(tg_get_message_id "$@")"
			elif [ "$(echo $RESULT | jq .description | cut -d "\"" -f 2)" = "Bad Request: user is an administrator of the chat" ]; then
				tg_send_message "$(tg_get_chat_id "$@")" "I can't unban this member, because it's an admin (and it's already in the chat)!" "$(tg_get_message_id "$@")"
			elif [ "$(echo $RESULT | jq .description | cut -d "\"" -f 2)" = "Bad Request: USER_ID_INVALID" ]; then
				tg_send_message "$(tg_get_chat_id "$@")" "Invalid user ID!" "$(tg_get_message_id "$@")"
			else
				tg_send_message "$(tg_get_chat_id "$@")" "Unknown error!" "$(tg_get_message_id "$@")"
			fi
		fi
	fi
}

module_kick() {
	if [ "$(tg_member_can_restrict_members "$(tg_get_chat_id "$@")" "$(tg_get_sender_id "$@")")" = true ]; then
		if [ "$(tg_get_sender_id "$(tg_get_reply_to_message "$@")")" != "null" ]; then
			local USER_ID=$(tg_get_sender_id "$(tg_get_reply_to_message "$@")")
		elif [ "$(tg_get_command_arguments "$@")" != "" ]; then
			if echo "$(tg_get_command_arguments "$@")" | grep -q "@"; then
				tg_send_message "$(tg_get_chat_id "$@")" "Kicking through username is not supported, reply to a message or provide a user id" "$(tg_get_message_id "$@")"
			else
				local USER_ID=$(tg_get_command_arguments "$@")
			fi
		else
			tg_send_message "$(tg_get_chat_id "$@")" "Please reply to a message or write the user id to kick that user" "$(tg_get_message_id "$@")"
		fi
		if [ "$USER_ID" != "" ]; then
			if [ "$USER_ID" = "$(tg_get_bot_user_id)" ]; then
				tg_send_message "$(tg_get_chat_id "$@")" "Why would I kick myself?" "$(tg_get_message_id "$@")"
				local USER_ID=""
			else
				local RESULT=$(tg_kick_user "$(tg_get_chat_id "$@")" "$USER_ID")
			fi
		fi
		if [ "$RESULT" != "" ]; then
			if [ "$(echo $RESULT | jq .ok)" = "true" ]; then
				tg_send_message "$(tg_get_chat_id "$@")" "$USER_ID kicked successfully" "$(tg_get_message_id "$@")"
			elif [ "$(echo $RESULT | jq .description | cut -d "\"" -f 2)" = "Bad Request: user is an administrator of the chat" ]; then
				tg_send_message "$(tg_get_chat_id "$@")" "I can't kick this member, because it's an admin!" "$(tg_get_message_id "$@")"
			elif [ "$(echo $RESULT | jq .description | cut -d "\"" -f 2)" = "Bad Request: USER_ID_INVALID" ]; then
				tg_send_message "$(tg_get_chat_id "$@")" "Invalid user ID!" "$(tg_get_message_id "$@")"
			else
				tg_send_message "$(tg_get_chat_id "$@")" "Unknown error!" "$(tg_get_message_id "$@")"
			fi
		fi
	fi
}

module_mute() {
	if [ "$(tg_member_can_restrict_members "$(tg_get_chat_id "$@")" "$(tg_get_sender_id "$@")")" = true ]; then
		if [ "$(tg_get_sender_id "$(tg_get_reply_to_message "$@")")" != "null" ]; then
			local USER_ID=$(tg_get_sender_id "$(tg_get_reply_to_message "$@")")
		elif [ "$(tg_get_command_arguments "$@")" != "" ]; then
			if echo "$(tg_get_command_arguments "$@")" | grep -q "@"; then
				tg_send_message "$(tg_get_chat_id "$@")" "Muting through username is not supported, reply to a message or provide a user id" "$(tg_get_message_id "$@")"
			else
				local USER_ID=$(tg_get_command_arguments "$@")
			fi
		else
			tg_send_message "$(tg_get_chat_id "$@")" "Please reply to a message or write the user id to mute that user" "$(tg_get_message_id "$@")"
		fi
		if [ "$USER_ID" != "" ]; then
			if [ "$USER_ID" = "$(tg_get_bot_user_id)" ]; then
				tg_send_message "$(tg_get_chat_id "$@")" "Why would I mute myself?" "$(tg_get_message_id "$@")"
				local USER_ID=""
			else
				local RESULT=$(tg_mute_user "$(tg_get_chat_id "$@")" "$USER_ID")
			fi
		fi
		if [ "$RESULT" != "" ]; then
			if [ "$(echo $RESULT | jq .ok)" = "true" ]; then
				tg_send_message "$(tg_get_chat_id "$@")" "$USER_ID muted successfully" "$(tg_get_message_id "$@")"
			elif [ "$(echo $RESULT | jq .description | cut -d "\"" -f 2)" = "Bad Request: user is an administrator of the chat" ]; then
				tg_send_message "$(tg_get_chat_id "$@")" "I can't mute this member, because it's an admin!" "$(tg_get_message_id "$@")"
			elif [ "$(echo $RESULT | jq .description | cut -d "\"" -f 2)" = "Bad Request: USER_ID_INVALID" ]; then
				tg_send_message "$(tg_get_chat_id "$@")" "Invalid user ID!" "$(tg_get_message_id "$@")"
			else
				tg_send_message "$(tg_get_chat_id "$@")" "Unknown error!" "$(tg_get_message_id "$@")"
			fi
		fi
	fi
}

module_unmute() {
	if [ "$(tg_member_can_restrict_members "$(tg_get_chat_id "$@")" "$(tg_get_sender_id "$@")")" = true ]; then
		if [ "$(tg_get_sender_id "$(tg_get_reply_to_message "$@")")" != "null" ]; then
			local USER_ID=$(tg_get_sender_id "$(tg_get_reply_to_message "$@")")
		elif [ "$(tg_get_command_arguments "$@")" != "" ]; then
			if echo "$(tg_get_command_arguments "$@")" | grep -q "@"; then
				tg_send_message "$(tg_get_chat_id "$@")" "Unmuting through username is not supported, reply to a message or provide a user id" "$(tg_get_message_id "$@")"
			else
				local USER_ID=$(tg_get_command_arguments "$@")
			fi
		else
			tg_send_message "$(tg_get_chat_id "$@")" "Please reply to a message or write the user id to unmute that user" "$(tg_get_message_id "$@")"
		fi
		if [ "$USER_ID" != "" ]; then
			if [ "$USER_ID" = "$(tg_get_bot_user_id)" ]; then
				tg_send_message "$(tg_get_chat_id "$@")" "Why would I unmute myself?" "$(tg_get_message_id "$@")"
				local USER_ID=""
			else
				local RESULT=$(tg_unmute_user "$(tg_get_chat_id "$@")" "$USER_ID")
			fi
		fi
		if [ "$RESULT" != "" ]; then
			if [ "$(echo $RESULT | jq .ok)" = "true" ]; then
				tg_send_message "$(tg_get_chat_id "$@")" "$USER_ID unmuted successfully" "$(tg_get_message_id "$@")"
			elif [ "$(echo $RESULT | jq .description | cut -d "\"" -f 2)" = "Bad Request: user is an administrator of the chat" ]; then
				tg_send_message "$(tg_get_chat_id "$@")" "I can't unmute this member, because it's an admin!" "$(tg_get_message_id "$@")"
			elif [ "$(echo $RESULT | jq .description | cut -d "\"" -f 2)" = "Bad Request: USER_ID_INVALID" ]; then
				tg_send_message "$(tg_get_chat_id "$@")" "Invalid user ID!" "$(tg_get_message_id "$@")"
			elif [ "$(echo $RESULT | jq .description | cut -d "\"" -f 2)" = "Bad Request: CHAT_ADMIN_REQUIRED" ]; then
				tg_send_message "$(tg_get_chat_id "$@")" "I can't unmute this member, because I don't have the permission to do it, or the member is an admin!" "$(tg_get_message_id "$@")"
			else
				echo $RESULT | jq .description | cut -d "\"" -f 2
				tg_send_message "$(tg_get_chat_id "$@")" "Unknown error!" "$(tg_get_message_id "$@")"
			fi
		fi
	fi
}
