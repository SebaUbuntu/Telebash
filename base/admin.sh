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

# Arguments: <chat_id> <user_id>
tg_get_member_is_bot() {
	tg_get_chat_member "$@" | jq ".user.is_bot"
}

# Arguments: <chat_id> <user_id>
tg_get_member_status() {
	tg_get_chat_member "$@" | jq ".status" | cut -d "\"" -f 2
}

# Arguments: <chat_id> <user_id>
tg_member_is_creator() {
	if [ "$(tg_get_member_status "$@")" = "creator" ]; then
		echo "true"
	else
		echo "false"
	fi
}

# Arguments: <chat_id> <user_id>
tg_member_can_be_edited() {
	if [ "$(tg_member_is_creator "$@")" = "true" ]; then
		echo "true"
	else
		tg_get_chat_member "$@" | jq ".can_be_edited"
	fi
}

# Arguments: <chat_id> <user_id>
tg_member_can_change_info() {
	if [ "$(tg_member_is_creator "$@")" = "true" ]; then
		echo "true"
	else
		tg_get_chat_member "$@" | jq ".can_change_info"
	fi
}

# Arguments: <chat_id> <user_id>
tg_member_can_delete_messages() {
	if [ "$(tg_member_is_creator "$@")" = "true" ]; then
		echo "true"
	else
		tg_get_chat_member "$@" | jq ".can_delete_messages"
	fi
}

# Arguments: <chat_id> <user_id>
tg_member_can_invite_users() {
	if [ "$(tg_member_is_creator "$@")" = "true" ]; then
		echo "true"
	else
		tg_get_chat_member "$@" | jq ".can_invite_users"
	fi
}

# Arguments: <chat_id> <user_id>
tg_member_can_restrict_members() {
	if [ "$(tg_member_is_creator "$@")" = "true" ]; then
		echo "true"
	else
		tg_get_chat_member "$@" | jq ".can_restrict_members"
	fi
}

# Arguments: <chat_id> <user_id>
tg_member_can_pin_messages() {
	if [ "$(tg_member_is_creator "$@")" = "true" ]; then
		echo "true"
	else
		tg_get_chat_member "$@" | jq ".can_pin_messages"
	fi
}

# Arguments: <chat_id> <user_id>
tg_member_can_promote_members() {
	if [ "$(tg_member_is_creator "$@")" = "true" ]; then
		echo "true"
	else
		tg_get_chat_member "$@" | jq ".can_pin_messages"
	fi
}