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
	if [ "$(tg_member_can_restrict_members "$(tg_get_chat_member "$(tg_get_chat_id "$@")" "$(tg_get_sender_id "$@")")")" = true ]; then
		if [ "$(tg_get_sender_id "$(tg_get_reply_to_message "$@")")" != "null" ]; then
			tg_ban_user "$(tg_get_chat_id "$@")" "$(tg_get_sender_id "$(tg_get_reply_to_message "$@")")"
			tg_send_message "$(tg_get_chat_id "$@")" "$(tg_get_sender_id "$(tg_get_reply_to_message "$@")") banned successfully" "$(tg_get_message_id "$@")"
		elif [ "$(tg_get_command_arguments "$@")" != "" ]; then
			if echo "$(tg_get_command_arguments "$1")" | grep -q "@"; then
				tg_send_message "$(tg_get_chat_id "$@")" "Banning through username is not supported, reply to a message or provide a user id" "$(tg_get_message_id "$@")"
			else
				tg_ban_user "$(tg_get_chat_id "$@")" "$(tg_get_command_arguments "$1")"
				tg_send_message "$(tg_get_chat_id "$@")" "$(tg_get_command_arguments "$1") banned successfully" "$(tg_get_message_id "$@")"
			fi
		else
			tg_send_message "$(tg_get_chat_id "$@")" "Please reply to a message or write the user id to unban that user" "$(tg_get_message_id "$@")"
		fi
	fi
}

module_unban() {
	if [ "$(tg_member_can_restrict_members "$(tg_get_chat_member "$(tg_get_chat_id "$@")" "$(tg_get_sender_id "$@")")")" = true ]; then
		if [ "$(tg_get_sender_id "$(tg_get_reply_to_message "$@")")" != "null" ]; then
			tg_unban_user "$(tg_get_chat_id "$@")" "$(tg_get_sender_id "$(tg_get_reply_to_message "$@")")"
			tg_send_message "$(tg_get_chat_id "$@")" "$(tg_get_sender_id "$(tg_get_reply_to_message "$@")") unbanned successfully" "$(tg_get_message_id "$@")"
		elif [ "$(tg_get_command_arguments "$@")" != "" ]; then
			if echo "$(tg_get_command_arguments "$1")" | grep -q "@"; then
				tg_send_message "$(tg_get_chat_id "$@")" "Unbanning through username is not supported, reply to a message or provide a user id" "$(tg_get_message_id "$@")"
			else
				tg_unban_user "$(tg_get_chat_id "$@")" "$(tg_get_command_arguments "$1")"
				tg_send_message "$(tg_get_chat_id "$@")" "$(tg_get_command_arguments "$1") kicked successfully" "$(tg_get_message_id "$@")"
			fi
		else
			tg_send_message "$(tg_get_chat_id "$@")" "Please reply to a message or write the username to unban that user" "$(tg_get_message_id "$@")"
		fi
	fi
}

module_kick() {
	if [ "$(tg_member_can_restrict_members "$(tg_get_chat_member "$(tg_get_chat_id "$@")" "$(tg_get_sender_id "$@")")")" = true ]; then
		if [ "$(tg_get_sender_id "$(tg_get_reply_to_message "$@")")" != "null" ]; then
			tg_kick_user "$(tg_get_chat_id "$@")" "$(tg_get_sender_id "$(tg_get_reply_to_message "$@")")"
			tg_send_message "$(tg_get_chat_id "$@")" "$(tg_get_sender_id "$(tg_get_reply_to_message "$@")") kicked successfully" "$(tg_get_message_id "$@")"
		elif [ "$(tg_get_command_arguments "$@")" != "" ]; then
			if echo "$(tg_get_command_arguments "$1")" | grep -q "@"; then
				tg_send_message "$(tg_get_chat_id "$@")" "Kicking through username is not supported, reply to a message or provide a user id" "$(tg_get_message_id "$@")"
			else
				tg_kick_user "$(tg_get_chat_id "$@")" "$(tg_get_command_arguments "$1")"
				tg_send_message "$(tg_get_chat_id "$@")" "$(tg_get_command_arguments "$1") kicked successfully" "$(tg_get_message_id "$@")"
			fi
		else
			tg_send_message "$(tg_get_chat_id "$@")" "Please reply to a message or write the username to kick that user" "$(tg_get_message_id "$@")"
		fi
	fi
}

module_mute() {
	if [ "$(tg_member_can_restrict_members "$(tg_get_chat_member "$(tg_get_chat_id "$@")" "$(tg_get_sender_id "$@")")")" = true ]; then
		if [ "$(tg_get_sender_id "$(tg_get_reply_to_message "$@")")" != "null" ]; then
			tg_mute_user "$(tg_get_chat_id "$@")" "$(tg_get_sender_id "$(tg_get_reply_to_message "$@")")"
			tg_send_message "$(tg_get_chat_id "$@")" "$(tg_get_sender_id "$(tg_get_reply_to_message "$@")") muted successfully" "$(tg_get_message_id "$@")"
		elif [ "$(tg_get_command_arguments "$@")" != "" ]; then
			if echo "$(tg_get_command_arguments "$1")" | grep -q "@"; then
				tg_send_message "$(tg_get_chat_id "$@")" "Muting through username is not supported, reply to a message or provide a user id" "$(tg_get_message_id "$@")"
			else
				tg_mute_user "$(tg_get_chat_id "$@")" "$(tg_get_command_arguments "$1")"
				tg_send_message "$(tg_get_chat_id "$@")" "$(tg_get_command_arguments "$1") muted successfully" "$(tg_get_message_id "$@")"
			fi
		else
			tg_send_message "$(tg_get_chat_id "$@")" "Please reply to a message or write the username to mute that user" "$(tg_get_message_id "$@")"
		fi
	fi
}

module_unmute() {
	if [ "$(tg_member_can_restrict_members "$(tg_get_chat_member "$(tg_get_chat_id "$@")" "$(tg_get_sender_id "$@")")")" = true ]; then
		if [ "$(tg_get_sender_id "$(tg_get_reply_to_message "$@")")" != "null" ]; then
			tg_unmute_user "$(tg_get_chat_id "$@")" "$(tg_get_sender_id "$(tg_get_reply_to_message "$@")")"
			tg_send_message "$(tg_get_chat_id "$@")" "$(tg_get_sender_id "$(tg_get_reply_to_message "$@")") unmuted successfully" "$(tg_get_message_id "$@")"
		elif [ "$(tg_get_command_arguments "$@")" != "" ]; then
			if echo "$(tg_get_command_arguments "$1")" | grep -q "@"; then
				tg_send_message "$(tg_get_chat_id "$@")" "Unmuting through username is not supported, reply to a message or provide a user id" "$(tg_get_message_id "$@")"
			else
				tg_unmute_user "$(tg_get_chat_id "$@")" "$(tg_get_command_arguments "$1")"
				tg_send_message "$(tg_get_chat_id "$@")" "$(tg_get_command_arguments "$1") unmuted successfully" "$(tg_get_message_id "$@")"
			fi
		else
			tg_send_message "$(tg_get_chat_id "$@")" "Please reply to a message or write the username to unmute that user" "$(tg_get_message_id "$@")"
		fi
	fi
}
