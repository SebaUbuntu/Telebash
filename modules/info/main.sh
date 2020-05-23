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

module_start() {
	tg_send_message "$(tg_get_chat_id "$@")" "Hi!
This is a multifunction bot, written in Bash by SebaUbuntu, because Python is boring

Version: $VERSION ($BRANCH)"
}

module_info() {
	tg_send_message "$(tg_get_chat_id "$@")" "\`\`\`
SebaUbuntu's Bash bot
Version: $VERSION ($BRANCH)

-----------------------------
Status: Working fine
Bash version: $BASH_VERSION
Linux kernel version: $(uname -r)
Architecture: $(uname -m)
-----------------------------
\`\`\`"
}

module_runs() {
	tg_send_message "$(tg_get_chat_id "$@")" "🏃"
}
