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

# Arguments: <chatid> <message_text>
tg_send_message() {
	curl -s -S -X POST "$TG_API_URL/sendMessage" -d chat_id="$1" -d text="$2" -d parse_mode="Markdown" | jq .
}

# Arguments: <chatid> <message_id> <message_text>
tg_edit_message() {
	curl -s -S -X POST "$TG_API_URL/editMessageText" -d chat_id="$1" -d message_id="$2" -d text="$3" parse_mode="Markdown" | jq .
}

# Arguments: <chatid> <document_path>
tg_send_file() {
	curl -s -S -X POST "$TG_API_URL/sendDocument" -d chat_id="$1" -F name=document -F document=@"$2" -H "Content-Type:multipart/form-data" | jq .
}
