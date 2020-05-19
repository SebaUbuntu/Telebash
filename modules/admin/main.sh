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

module_ban() {
	if [ "$(get_sender_id "$(get_reply_to_message "$@")")" != "null" ]; then
		ban_user "$(get_chat_id "$@")" "$(get_sender_id "$(get_reply_to_message "$@")")"
		send_message "$(get_chat_id "$@")" "$(get_sender_id "$(get_reply_to_message "$@")") banned successfully"
	else
		send_message "$(get_chat_id "$@")" "Please reply to a message to ban whoever sent it"
	fi
}

module_unban() {
	if [ "$(get_sender_id "$(get_reply_to_message "$@")")" != "null" ]; then
		unban_user "$(get_chat_id "$@")" "$(get_sender_id "$(get_reply_to_message "$@")")"
		send_message "$(get_chat_id "$@")" "$(get_sender_id "$(get_reply_to_message "$@")") unbanned successfully"
	else
		send_message "$(get_chat_id "$@")" "Please reply to a message to ban whoever sent it"
	fi
}

module_kick() {
	if [ "$(get_sender_id "$(get_reply_to_message "$@")")" != "null" ]; then
		kick_user "$(get_chat_id "$@")" "$(get_sender_id "$(get_reply_to_message "$@")")"
		send_message "$(get_chat_id "$@")" "$(get_sender_id "$(get_reply_to_message "$@")") kicked successfully"
	else
		send_message "$(get_chat_id "$@")" "Please reply to a message to ban whoever sent it"
	fi
}

module_mute() {
	#send_message "$(get_chat_id "$@")" "Muted successfully"
	send_message "$(get_chat_id "$@")" "WIP"
}

module_unmute() {
	#send_message "$(get_chat_id "$@")" "Unmuted successfully"
	send_message "$(get_chat_id "$@")" "WIP"
}
