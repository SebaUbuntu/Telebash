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

import_variables() {
	export TG_BOT_TOKEN=
	export CI_APPROVED_USER_IDS= # Add user ID and separate them with a space
	export CI_MAIN_DIR= # This folder needs to contain every ROMs and recoveries sources with proper folder naming (eg. the folder contains "LineageOS-17.1" folder, so when you launch the command it will cd into Lineage-17.1 folder and starting building). DON'T add a slash at the end of the path (eg. /home/user)
	export CI_CHANNEL_ID= # Add channel ID/username or group ID to use for updates posting
	export CI_ENABLE_GDRIVE_UPLOAD=false # (please read this entire comment before enabling it) Upload artifacts to a Google Drive if the CI script supports it by setting it to true. Note: You must configure it before you enable this flag; read https://github.com/labbots/google-drive-upload#generating-oauth-credentials and https://github.com/labbots/google-drive-upload#first-run to configure it
}

import_more_variables() {
	export TG_API_URL=https://api.telegram.org/bot$TG_BOT_TOKEN
}

