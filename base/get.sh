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
get_updates() {
	curl -s -X GET "$TG_API_URL/getUpdates" $@ | jq .
}

# Arguments: <curl arguments>
get_unread_updates() {
	get_updates $@ | jq ".result | .[]"
}

# Arguments: <curl arguments>
get_unread_updates_number() {
	get_updates $@ | jq ".result | length"
}

# Arguments: <curl arguments>
get_last_update_id() {
	UPDATE_NUMBER=$(get_unread_updates_number)
	UPDATE_NUMBER=$(( "UPDATES_NUMBER" - "1" ))
	get_updates $@ | jq ".result | .[$UPDATE_NUMBER] | .update_id"
}

# Arguments: <update number> <offset>
get_specific_update() {
	UPDATE_NUMBER=$1
	shift
	get_updates "offset=$2" | jq ".result | .[$UPDATE_NUMBER]"
}

# Arguments: <update in JSON>
get_message() {
	echo "$@" | jq ".message"
}

# Arguments: <message in JSON>
get_reply_to_message() {
	get_message "$@" | jq "{message: .reply_to_message}"
}

# Arguments: <message in JSON>
get_message_id() {
	get_message "$@" | jq ".message_id"
}

# Arguments: <message in JSON>
get_sender_id() {
	get_message "$@" | jq ".from.id"
}

# Arguments: <message in JSON>
get_chat_id() {
	get_message "$@" | jq ".chat.id"
}

# Arguments: <message in JSON>
get_chat_type() {
	get_message "$@" | jq ".chat.type"
}

# Arguments: <message in JSON>
get_message_text() {
	get_message "$@" | jq ".text" | cut -d "\"" -f 2
}
