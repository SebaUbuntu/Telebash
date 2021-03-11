#!/bin/bash
#
# Copyright (C) 2021 Telebash
#
# SPDX-License-Identifier: Apache-2.0
#

# Main wrapper, source all the components
source variables.sh
source base/get.sh
source base/modules.sh
source base/updates.sh

telegram() {
	local ACTION="${1}"
	local CURL_ARGUMENTS=()
	case "${ACTION}" in
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
	curl -s "https://api.telegram.org/bot${TG_BOT_TOKEN}/${ACTION}" "${CURL_ARGUMENTS[@]}" "${FILE_ARGUMENT}" | jq .
}
