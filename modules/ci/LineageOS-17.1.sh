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

# Source variables and basic functions
source variables.sh
source base/telegram_get.sh
source base/get.sh
source base/telegram_send.sh

import_variables
import_more_variables

ci_parse_arguments() {
	while [ "${#}" -gt 0 ]; do
		case "${1}" in
			-h | --help )
				CI_USER_NEEDS_HELP=true
				;;
			-c | --clean )
				CI_CLEAN=clean
				;;
			-ic | --installclean )
				CI_CLEAN=installclean
				;;
			-d | --device )
				CI_DEVICE="${2}"
				shift
				;;
		esac
		shift
	done
}

ci_help() {
	tg_send_message "$(tg_get_chat_id "$1")" "$2
Usage: \`/ci <device codename> [arguments]\`
 \`-d <codename>\` (specify device codename)
 \`-c\` (if you want to do a clean build) (optional)
 \`-ic\` (if you want to cleanup previous output with installclean) (optional)" "$(tg_get_message_id "$@")"
	exit
}

ci_message() {
	if [ "$CI_MESSAGE_ID" = "" ]; then
		CI_MESSAGE_ID=$(tg_send_message "$CI_CHANNEL_ID" "CI | LineageOS 17.1 (Q)
Device: $CI_DEVICE

Status: $1" | jq .result.message_id)
	else
		tg_edit_message_text "$CI_CHANNEL_ID" "$CI_MESSAGE_ID" "CI | LineageOS 17.1 (Q)
Device: $CI_DEVICE

Status: $1"
	fi
}

ci_parse_arguments $(tg_get_command_arguments "$@")
if [ "$CI_USER_NEEDS_HELP" = true ]; then
	ci_help "$@"
fi
if [ "$CI_DEVICE" != "" ] && [ -d "$CI_MAIN_DIR/LineageOS-17.1" ]; then
	ci_message "Starting..."
	if [ "$CI_MESSAGE_ID" != "" ]; then
		cd "$CI_MAIN_DIR/LineageOS-17.1"
		ci_message "Setting up environment..."
		. build/envsetup.sh
		export SKIP_ABI_CHECKS=true
		ci_message "Lunching..."
		lunch lineage_${CI_DEVICE}-userdebug
		CI_LUNCH_STATUS=$?
		if [ $CI_LUNCH_STATUS = 0 ]; then
			if [ "$CI_CLEAN" = "clean" ]; then
				ci_message "Cleaning..."
				mka clean
			elif [ "$CI_CLEAN" = "installclean" ]; then
				ci_message "Cleaning..."
				mka installclean
			fi
			ci_message "Building..."
			mka bacon -j$(nproc --all)
			CI_BUILD_STATUS=$?
			if [ $CI_BUILD_STATUS = 0 ]; then
				if [ "$CI_ENABLE_GDRIVE_UPLOAD" = "true" ] && [ "$(command -v gupload > /dev/null 2>&1 && echo 0)" = "0" ]; then
					ci_message "Build completed, uploading..."
					CI_UPLOAD_LINK=$(gupload out/target/product/$CI_DEVICE/lineage-*.zip | grep "https://drive.google.com/open?id=" | sed "s/[][]//g" | tr -d '[:space:]')
					if [ "$CI_UPLOAD_LINK" != "" ]; then
						ci_message "Build completed
Link: $CI_UPLOAD_LINK"
					else
						ci_message "Build completed, upload failed"
					fi
				else
					ci_message "Build completed"
				fi
			else
				ci_message "Failed at building"
			fi
		else
			ci_message "Failed at lunch"
		fi
	else
		tg_send_message "$(tg_get_chat_id "$@")" "Error: specified CI channel or user ID is invalid" "$(tg_get_message_id "$@")"
	fi
else
	ci_help "$@" "Error: missing arguments or wrong building path"
fi
