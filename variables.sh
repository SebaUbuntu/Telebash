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
	export CI_MAIN_DIR= # This folder needs to contain every ROMs and recoveries sources with proper folder naming (eg. the folder contains "LineageOS-17.1" folder, so when you launch the command it will cd into Lineage-17.1 folder and starting building). Add a slash at the end of the path (eg. /home/user/)
}

import_more_variables() {
	export TG_API_URL=https://api.telegram.org/bot$TG_BOT_TOKEN
}

