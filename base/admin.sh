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

# Arguments: <chat_id> <user_id>
tg_get_chat_member() {
	curl -s -X GET "$TG_API_URL/getChatMember" -d chat_id="$1" -d user_id="$2" | jq ".result"
}

# Arguments: <chat_id> <user_id>
tg_user_can_restrict_members() {
	if [ "$(tg_get_chat_member "$@" | jq ".status" | cut -d "\"" -f 2)" = "creator" ]; then
		echo "True"
	else
		tg_get_chat_member "$@" | jq ".can_restrict_members"
	fi
}