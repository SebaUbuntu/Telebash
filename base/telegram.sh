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

# Main wrapper, source all the components
source variables.sh
source base/get.sh
source base/modules.sh
source base/updates.sh

telegram() {
	local ACTION=${1}
	local CURL_ARGUMENTS=()
	case $ACTION in
		sendAnimation | sendAudio | sendDocument | sendPhoto | sendVideo)
		HTTP_REQUEST=POST_FILE
		;;
		*)
		HTTP_REQUEST=GET
		;;
	esac
	while [ "${#}" -gt 0 ]; do
		case "${1}" in
			--animation | --audio | --document | --photo | --video )
				local FILE_ARGUMENT="-F $(echo "${1}" | sed 's/--//')=@${2}"
				shift
				;;
			--* )
				if [ "$HTTP_REQUEST" != "POST_FILE" ]; then
					local CURL_ARGUMENTS+=(-d $(echo "${1}" | sed 's/--//')="${2}")
				else
					local CURL_ARGUMENTS+=(-F $(echo "${1}" | sed 's/--//')="${2}")
				fi
				shift
				;;
		esac
		shift
	done
	curl -s "https://api.telegram.org/bot$TG_BOT_TOKEN/$ACTION" "${CURL_ARGUMENTS[@]}" "$FILE_ARGUMENT" | jq .
}
