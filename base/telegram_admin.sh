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
	telegram_main kickChatMember GET "$@"
}

# Arguments: <chat_id> <user_id>
tg_unban_user() {
	telegram_main unbanChatMember GET "$@"
}

# Arguments: <chat_id> <user_id>
tg_kick_user() {
	local RESULT=$(telegram_main kickChatMember GET "$@")
	if [ "$(echo "$RESULT" | jq .ok)" = "true" ]; then
		telegram_main unbanChatMember GET "$@"
	else
		echo $RESULT | jq .
	fi
}

# Arguments: <chat_id> <user_id>
tg_mute_user() {
	telegram_main restrictChatMember GET "$@" --permissions "{\"can_send_messages\": false, \"can_send_media_messages\": false, \"can_send_polls\": false, \"can_send_other_messages\": false, \"can_add_web_page_previews\": false, \"can_change_info\": false, \"can_invite_users\": false, \"can_pin_messages\": false}"
}

# Arguments: <chat_id> <user_id>
tg_unmute_user() {
	telegram_main restrictChatMember GET "$@" --permissions "{\"can_send_messages\": true, \"can_send_media_messages\": true, \"can_send_polls\": true, \"can_send_other_messages\": true, \"can_add_web_page_previews\": true, \"can_change_info\": true, \"can_invite_users\": true, \"can_pin_messages\": true}"
}