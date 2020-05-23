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

# Source variables and basic functions
source variables.sh
source base/get.sh
source base/send.sh

import_variables
import_more_variables

THREADS=$(nproc --all)

ci_parse_arguments() {
	while [ "${#}" -gt 0 ]; do
		case "${1}" in
			-t | --type )
				CI_TYPE="${2}"
				shift
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
			-p | --prefix )
				CI_LUNCH_PREFIX="${2}"
				shift
				;;
			* )
				CI_PROJECT="${1}"
				;;
		esac
		shift
	done
}

ci_edit_message() {
	tg_edit_message "$(tg_get_chat_id "$1")" "$CI_MESSAGE_ID" "CI building
Device: $CI_DEVICE
Type: $CI_TYPE
$CI_TYPE project: $CI_PROJECT
Status: $2"
}

ci_parse_arguments $(tg_get_message_text "$@" | cut -d' ' -f2-)
if [ "$CI_DEVICE" != "" ] && [ "$CI_PROJECT" != "" ] && [ "$CI_TYPE" != "" ] && $([ "$CI_TYPE" = "Recovery" ] || $([ "$CI_TYPE" = "ROM" ] && [ "$CI_LUNCH_PREFIX" != "" ])) && [ -d "$CI_MAIN_DIR/$CI_PROJECT" ]; then
	CI_MESSAGE_ID=$(tg_send_message "$(tg_get_chat_id "$@")" "CI building
Device: $CI_DEVICE
Type: $CI_TYPE
$CI_TYPE project: $CI_PROJECT
Status: Waking up..." | jq .result.message_id)
	cd "$CI_MAIN_DIR/$CI_PROJECT"
	ci_edit_message "$@" "Setting up environment..."
	. build/envsetup.sh
	ci_edit_message "$@" "Lunching..."
	if [ "$CI_TYPE" = "Recovery" ]; then
		lunch omni_${CI_DEVICE}-eng
		CI_LUNCH_STATUS=$?
	else
		lunch ${CI_LUNCH_PREFIX}_${CI_DEVICE}-userdebug
		CI_LUNCH_STATUS=$?
	fi
	if [ $CI_LUNCH_STATUS = 0 ]; then
		if [ "$CI_CLEAN" = "clean" ]; then
			mka clean
		elif [ "$CI_CLEAN" = "installclean" ]; then
			mka installclean
		fi
		if [ "$CI_TYPE" = "Recovery" ]; then
			mka recoveryimage -j$THREADS
			CI_BUILD_STATUS=$?
		else
			mka bacon -j$THREADS
			CI_BUILD_STATUS=$?
		fi
		if [ $CI_BUILD_STATUS = 0 ]; then
			ci_edit_message "$@" "Build completed"
		else
			ci_edit_message "$@" "Failed at building"
		fi
	else
		ci_edit_message "$@" "Failed at lunch"
	fi
else
	tg_send_message "$(tg_get_chat_id "$@")" "CI building failed: missing arguments or wrong building path
\`\`\`
Usage: /ci <dir path> [arguments]
 -d <codename> 
 -t <\"ROM\" or \"recovery\">
 -p <lunch prefix> (only used when build type is ROM, it's used with lunch command e.g. lunch \${prefix}_device-userdebug)
 -c (if you want to do a clean build)
 -ic (if you want to cleanup previous output with installclean)
\`\`\`"
fi
