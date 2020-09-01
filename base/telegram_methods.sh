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

# Arguments: <curl arguments>
tg_get_updates() {
	telegram_main getUpdates GET "$@"
}

# Arguments: none
tg_get_me() {
	telegram_main getMe GET "$@"
}

# Arguments: <chatid> <message_text> <message_id (for reply, optional)>
tg_send_message() {
	telegram_main sendMessage POST "$@"
}

# Arguments: <chatid> <file_path> <message_id (for reply, optional)>
tg_send_photo() {
	telegram_main sendPhoto POST_FILE "$@"
}

# Arguments: <chatid> <file_path> <message_id (for reply, optional)>
tg_send_audio() {
	telegram_main sendAudio POST_FILE "$@"
}

# Arguments: <chatid> <file_path> <message_id (for reply, optional)>
tg_send_document() {
	telegram_main sendDocument POST_FILE "$@"
}

# Arguments: <chatid> <file_path> <message_id (for reply, optional)>
tg_send_video() {
	telegram_main sendVideo POST_FILE "$@"
}

# Arguments: <chatid> <file_path> <message_id (for reply, optional)>
tg_send_animation() {
	telegram_main sendAnimation POST_FILE "$@"
}

# Arguments: <chatid> <emoji> <message_id (for reply, optional)>
tg_send_dice() {
	telegram_main sendDice POST "$@"
}

# Arguments: <chat_id> <user_id>
tg_ban_user() {
	telegram_main kickChatMember GET "$@"
}

# Arguments: <chat_id> <user_id>
tg_unban_user() {
	telegram_main unbanChatMember GET "$@"
}

# Arguments: <chat_id> <user_id>
tg_restrict_chat_member() {
	telegram_main restrictChatMember GET "$@"
}

# Arguments: <chat_id> <user_id>
tg_get_chat_member() {
	telegram_main getChatMember GET "$@"
}

# Arguments: <chatid> <message_id> <message_text>
tg_edit_message_text() {
	telegram_main editMessageText POST "$@"
}

# Arguments: <chatid> <message_id> <message_text>
tg_edit_message_caption() {
	telegram_main editMessageMedia POST "$@"
}