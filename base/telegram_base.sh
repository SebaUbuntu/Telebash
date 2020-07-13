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

telegram_curl() {
	local ACTION=${1}
	shift
	local HTTP_REQUEST=${1}
	shift
	if [ "$HTTP_REQUEST" != "POST_FILE" ]; then
		curl -s -X $HTTP_REQUEST "https://api.telegram.org/bot$TG_BOT_TOKEN/$ACTION" "$@" | jq .
	else
		curl -s "https://api.telegram.org/bot$TG_BOT_TOKEN/$ACTION" "$@" | jq .
	fi
}

telegram_main() {
	local ACTION=${1}
	local HTTP_REQUEST=${2}
	local CURL_ARGUMENTS=()
	while [ "${#}" -gt 0 ]; do
		case "${1}" in
			--animation | --audio | --document | --photo | --video )
				local CURL_ARGUMENTS+=(-F $(echo "${1}" | sed 's/--//')=@"${2}")
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
	telegram_curl "$ACTION" "$HTTP_REQUEST" "${CURL_ARGUMENTS[@]}"
}

telegram_curl_get() {
	local ACTION=${1}
	shift
	telegram_main "$ACTION" GET "$@"
}

telegram_curl_post() {
	local ACTION=${1}
	shift
	telegram_main "$ACTION" POST "$@"
}

telegram_curl_post_file() {
	local ACTION=${1}
	shift
	telegram_main "$ACTION" POST_FILE "$@"
}