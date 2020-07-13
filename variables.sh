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

# Bot
# Add here your HTTP API bot token, get it from @BotFather
export TG_BOT_TOKEN=

# Module - CI
# Add user ID and separate them with a space
export CI_APPROVED_USER_IDS=
# This folder needs to contain every ROMs and recoveries sources with proper folder naming (eg. the folder contains "LineageOS-17.1" folder, so when you launch the command it will cd into Lineage-17.1 folder and starting building). DON'T add a slash at the end of the path (eg. /home/user)
export CI_MAIN_DIR=
# Add channel ID/username or group ID to use for updates posting
export CI_CHANNEL_ID=
# Upload artifacts if the CI script supports it by setting it to true.
export CI_UPLOAD_ARTIFACTS=false
# (please read the entire explanation) Define where to upload CI artifacts, the supported methods are: "gdrive" (Google Drive) and "mega" (MEGA)
# gdrive: Based on gupload script from labbots, get it from https://github.com/labbots/google-drive-upload and install it. You must first of all also configure it, read https://github.com/labbots/google-drive-upload#generating-oauth-credentials and https://github.com/labbots/google-drive-upload#first-run to configure it
# mega: Based on MEGAcmd, get it from https://mega.nz/cmd. You must first of all do login with the following command: "mega-login <username> <password>" then upload a random file with "mega-put <filename> /" and then create a share link with "mega-export -a /<filename>" and agree to the MEGA ToS
export CI_ARTIFACTS_UPLOAD_METHOD=
