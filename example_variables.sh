#!/bin/bash
#
# Copyright (C) 2021 Telebash
#
# SPDX-License-Identifier: Apache-2.0
#

# Bot
# Add here your HTTP API bot token, get it from @BotFather
export TG_BOT_TOKEN=

# Module - CI
# Read this before continuing: https://github.com/SebaUbuntu/Telebash/wiki/Module-%7C-CI#variables
export CI_APPROVED_USER_IDS=
export CI_MAIN_DIR=
export CI_CHANNEL_ID=
export CI_UPLOAD_ARTIFACTS=false
export CI_ARTIFACTS_UPLOAD_METHOD=
# If you use SourceForge upload method, please fill the following variables:
export CI_SF_PROJECT=
export CI_SF_USER=
export CI_SF_PASS=
# If you use local copy method, please fill the following variables:
export CI_LOCAL_COPY_DIR=

# Module - Weather
# Read this before continuing: https://github.com/SebaUbuntu/Telebash/wiki/Module-%7C-Weather#variables
export WEATHER_API_KEY=
export WEATHER_TEMP_UNIT="metric"
