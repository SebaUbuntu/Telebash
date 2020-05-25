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
tg_ban_user() {
	curl -s -X GET "$TG_API_URL/kickChatMember" -d chat_id="$1" -d user_id="$2" | jq .
}

# Arguments: <chat_id> <user_id>
tg_unban_user() {
	curl -s -X GET "$TG_API_URL/unbanChatMember" -d chat_id="$1" -d user_id="$2" | jq .
}

# Arguments: <chat_id> <user_id>
tg_kick_user() {
	curl -s -X GET "$TG_API_URL/kickChatMember" -d chat_id="$1" -d user_id="$2" | jq .
	curl -s -X GET "$TG_API_URL/unbanChatMember" -d chat_id="$1" -d user_id="$2" | jq .
}

# Arguments: <"all" or "none">
tg_make_user_permission_list() {
	if [ "$1" = "all" ]; then
		echo "{\"can_send_messages\": true, \"can_send_media_messages\": true, \"can_send_polls\": true, \"can_send_other_messages\": true, \"can_add_web_page_previews\": true, \"can_change_info\": true, \"can_invite_users\": true, \"can_pin_messages\": true}" | jq .
	elif [ "$1" = "none" ]; then
		echo "{\"can_send_messages\": false, \"can_send_media_messages\": false, \"can_send_polls\": false, \"can_send_other_messages\": false, \"can_add_web_page_previews\": false, \"can_change_info\": false, \"can_invite_users\": false, \"can_pin_messages\": false}" | jq .
	fi
}

# Arguments: <chat_id> <user_id>
tg_mute_user() {
	curl -s -X GET "$TG_API_URL/restrictChatMember" -d chat_id="$1" -d user_id="$2" -d permissions="$(tg_make_user_permission_list "none")" | jq .
}

# Arguments: <chat_id> <user_id>
tg_unmute_user() {
	curl -s -X GET "$TG_API_URL/restrictChatMember" -d chat_id="$1" -d user_id="$2" -d permissions="$(tg_make_user_permission_list "all")" | jq .
}