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
source base/telegram_base.sh
source base/telegram_get.sh
source base/get.sh
source base/telegram_send.sh

# Source common uploading functions
source modules/ci/upload.sh

# Parse arguments passed by the ROM or recovery's script
while [ "${#}" -gt 0 ]; do
	case "${1}" in
		--project )
			CI_AOSP_PROJECT="${2}"
			shift
			;;
		--name )
			CI_AOSP_PROJECT_NAME="${2}"
			shift
			;;
		--version )
			CI_AOSP_PROJECT_VERSION="${2}"
			shift
			;;
		--lunch_prefix )
			CI_LUNCH_PREFIX="${2}"
			shift
			;;
		--lunch_suffix )
			CI_LUNCH_SUFFIX="${2}"
			shift
			;;
		--build_target )
			CI_BUILD_TARGET="${2}"
			shift
			;;
		--artifacts )
			CI_OUT_ARTIFACTS_NAME="${2}"
			shift
			;;
		* )
			MESSAGE="${1}"
			;;
	esac
	shift
done

# Function to provide help for the CI project
ci_help() {
	tg_send_message --chat_id "$(tg_get_chat_id "$MESSAGE")" --text "$2
Usage: \`/ci $CI_AOSP_PROJECT [arguments]\`
 \`-d <codename>\` (specify device codename)
 \`-c\` (if you want to do a clean build) (optional)
 \`-ic\` (if you want to cleanup previous output with installclean) (optional)" --reply_to_message_id "$(tg_get_message_id "$MESSAGE")" --parse_mode "Markdown"
	exit
}

# Parse arguments passed by the user with the Telegram message sent to the bot
ci_parse_arguments() {
	while [ "${#}" -gt 0 ]; do
		case "${1}" in
			-h | --help )
				ci_help "$MESSAGE"
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

# Common CI post update function
ci_message() {
	if [ "$CI_MESSAGE_ID" = "" ]; then
		CI_MESSAGE_ID=$(tg_send_message --chat_id "$CI_CHANNEL_ID" --text "🛠 CI | $CI_AOSP_PROJECT_NAME ($CI_AOSP_PROJECT_VERSION)
Device: $CI_DEVICE
Lunch flavor: ${CI_LUNCH_PREFIX}\_${CI_DEVICE}-${CI_LUNCH_SUFFIX}

Status: $1" --parse_mode "Markdown" | jq .result.message_id)
	else
		tg_edit_message_text --chat_id "$CI_CHANNEL_ID" --message_id "$CI_MESSAGE_ID" --text "🛠 CI | $CI_AOSP_PROJECT_NAME ($CI_AOSP_PROJECT_VERSION)
Device: $CI_DEVICE
Lunch flavor: ${CI_LUNCH_PREFIX}\_${CI_DEVICE}-${CI_LUNCH_SUFFIX}

Status: $1" --parse_mode "Markdown"
	fi
}

# Function to update the links list of the CI message
ci_update_links_in_message() {
	ci_message "Build completed in $(( CI_BUILD_DURATION / 60 )) minute(s) and $(( CI_BUILD_DURATION % 60 )) seconds

Uploading $CI_CURRENT_ARTIFACTS_NUMBER out of $CI_ARTIFACTS_NUMBER artifact(s)
File hosting: $(ci_name)
$CI_UPLOAD_LINKS"
}

# Function to add an entry to the links list
ci_add_link_to_list() {
	if [ "$CI_UPLOAD_LINKS" = "" ]; then
		CI_UPLOAD_LINKS="$1"
	else
		CI_UPLOAD_LINKS="$CI_UPLOAD_LINKS
$1"
	fi
}

ci_parse_arguments $(tg_get_command_arguments "$MESSAGE")

if [ "$CI_DEVICE" = "" ] || [ ! -d "$CI_MAIN_DIR/$CI_AOSP_PROJECT" ]; then
	echo "$CI_DEVICE"
	echo "$CI_MAIN_DIR/$CI_AOSP_PROJECT"
	ci_help "$MESSAGE" "Error: missing arguments or wrong building path"
fi

ci_message "Starting..."
# If message failed to send, just report it an abort
if [ "$CI_MESSAGE_ID" = "" ]; then
	tg_send_message --chat_id "$(tg_get_chat_id "$MESSAGE")" --text "Error: specified CI channel or user ID is invalid" --reply_to_message_id "$(tg_get_message_id "$MESSAGE")"
	exit
fi

CI_BUILD_START=$(date +"%s")

cd "${CI_MAIN_DIR}/${CI_AOSP_PROJECT}"
ci_message "Setting up environment..."
. build/envsetup.sh

ci_message "Lunching..."
lunch ${CI_LUNCH_PREFIX}_${CI_DEVICE}-${CI_LUNCH_SUFFIX} &> lunch_log.txt
CI_LUNCH_STATUS=$?
if [ $CI_LUNCH_STATUS != 0 ]; then
	CI_BUILD_END=$(date +"%s")
	CI_BUILD_DURATION=$(( CI_BUILD_END - CI_BUILD_START ))
	ci_message "Build failed at lunch in $(( CI_BUILD_DURATION / 60 )) minute(s) and $(( CI_BUILD_DURATION % 60 )) seconds"
	tg_send_document --chat_id "$CI_CHANNEL_ID" --document "lunch_log.txt" --reply_to_message_id "$CI_MESSAGE_ID"
	exit
fi

if [ "$CI_CLEAN" != "" ]; then
	ci_message "Cleaning (mka $CI_CLEAN)..."
	mka $CI_CLEAN &> clean_log.txt
	CI_CLEAN_STATUS=$?
	if [ $CI_CLEAN_STATUS != 0 ]; then
		CI_BUILD_END=$(date +"%s")
		CI_BUILD_DURATION=$(( CI_BUILD_END - CI_BUILD_START ))
		ci_message "Build failed at cleaning in $(( CI_BUILD_DURATION / 60 )) minute(s) and $(( CI_BUILD_DURATION % 60 )) seconds"
		tg_send_document --chat_id "$CI_CHANNEL_ID" --document "clean_log.txt" --reply_to_message_id "$CI_MESSAGE_ID"
		exit
	fi
fi

ci_message "Building..."
mka $CI_BUILD_TARGET -j$(nproc --all) &> build_log.txt
CI_BUILD_STATUS=$?
if [ $CI_BUILD_STATUS != 0 ]; then
	CI_BUILD_END=$(date +"%s")
	CI_BUILD_DURATION=$(( CI_BUILD_END - CI_BUILD_START ))
	ci_message "Build failed at building in $(( CI_BUILD_DURATION / 60 )) minute(s) and $(( CI_BUILD_DURATION % 60 )) seconds"
	tg_send_document --chat_id "$CI_CHANNEL_ID" --document "build_log.txt" --reply_to_message_id "$CI_MESSAGE_ID"
	exit
fi

CI_BUILD_END=$(date +"%s")
CI_BUILD_DURATION=$(( CI_BUILD_END - CI_BUILD_START ))

# If uploading is disabled, just update the post with the time taken to build
if [ "$CI_UPLOAD_ARTIFACTS" != true ] || [ "$CI_ARTIFACTS_UPLOAD_METHOD" = "" ]; then
	ci_message "Build completed in $(( CI_BUILD_DURATION / 60 )) minute(s) and $(( CI_BUILD_DURATION % 60 )) seconds"
	exit
fi

# Parse all artifacts to upload
CI_ARTIFACTS_NUMBER=0
CI_CURRENT_ARTIFACTS_NUMBER=0
for artifact in $(ls out/target/product/$CI_DEVICE/$CI_OUT_ARTIFACTS_NAME); do
	CI_ARTIFACTS_NUMBER=$(( CI_ARTIFACTS_NUMBER + 1 ))
done

for artifact in $(ls out/target/product/$CI_DEVICE/$CI_OUT_ARTIFACTS_NAME); do
	# Increase current artifact counter
	CI_CURRENT_ARTIFACTS_NUMBER=$(( CI_CURRENT_ARTIFACTS_NUMBER + 1 ))
	ci_update_links_in_message
	# Upload the artifact
	# TODO: Stop using hardcoded AOSP project type
	CI_CURRENT_ARTIFACT_LINK=$(ci_upload "$artifact" "ROMs" "$CI_AOSP_PROJECT" "$CI_DEVICE")
	if [ "$CI_CURRENT_ARTIFACT_LINK" != "" ] || [ "$CI_CURRENT_ARTIFACT_LINK" != "WIP" ]; then
		# It's a valid link, add it to artifact list
		ci_add_link_to_list "$CI_CURRENT_ARTIFACTS_NUMBER): [$(basename "$artifact" | sed 's/_/\\_/g')]($CI_CURRENT_ARTIFACT_LINK)"
	else
		# Report in the message that this artifact's upload has failed
		ci_add_link_to_list "$CI_CURRENT_ARTIFACTS_NUMBER): $(basename "$artifact" | sed 's/_/\\_/g'): Upload failed"
	fi
	ci_update_links_in_message
done

# Conclude the process
CI_UPLOAD_MESSAGE="Build completed in $(( CI_BUILD_DURATION / 60 )) minute(s) and $(( CI_BUILD_DURATION % 60 )) seconds

Uploaded $CI_CURRENT_ARTIFACTS_NUMBER out of $CI_ARTIFACTS_NUMBER artifact(s)
File hosting: $(ci_name)
$CI_UPLOAD_LINKS"
ci_message "$CI_UPLOAD_MESSAGE"
