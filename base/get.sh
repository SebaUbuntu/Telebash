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

# Arguments: -d offset=$offset
get_updates() {
	curl -s -X GET "$TG_API_URL/getUpdates" $@ | jq .
}

get_unread_updates() {
	get_updates $@ | jq ".result | .[]"
}

get_unread_updates_number() {
	get_updates $@ | jq ".result | length"
}

get_last_update_id() {
	UPDATE_NUMBER=$(get_unread_updates_number)
	UPDATE_NUMBER=$(( "UPDATES_NUMBER" - "1" ))
	get_updates $@ | jq ".result | .[$UPDATE_NUMBER] | .update_id"
}

get_specific_update() {
	UPDATE_NUMBER=$1
	shift
	get_updates "offset=$2" | jq ".result | .[$UPDATE_NUMBER]"
}

get_message() {
	echo "$@" | jq ".message"
}

get_reply_to_message() {
	get_message "$@" | jq "{message: .reply_to_message}"
}

get_message_id() {
	get_message "$@" | jq ".message_id"
}

get_sender_id() {
	get_message "$@" | jq ".from.id"
}

get_chat_id() {
	get_message "$@" | jq ".chat.id"
}

get_chat_type() {
	get_message "$@" | jq ".chat.type"
}

get_message_text() {
	get_message "$@" | jq ".text" | cut -d "\"" -f 2
}
