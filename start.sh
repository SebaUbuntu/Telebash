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

import_variables
import_more_variables

if [ $(get_updates | jq .ok) = "true" ]; then
    LAST_UPDATE_ID=$(get_last_update_id)
    while [ 0 != 1 ]; do
        UNREAD_UPDATES_NUMBER="$(get_unread_updates_number -d offset="$LAST_UPDATE_ID")"
        if [ "$UNREAD_UPDATES_NUMBER" != "0" ]; then
            CURRENT_UPDATES_NUMBER=0
            echo "Found $UNREAD_UPDATES_NUMBER update(s)"
            while [ "$UNREAD_UPDATES_NUMBER" -gt "$CURRENT_UPDATES_NUMBER" ]; do
                base/main.sh "$CURRENT_UPDATES_NUMBER" "$LAST_UPDATE_ID"
                CURRENT_UPDATES_NUMBER=$(( CURRENT_UPDATES_NUMBER + 1 ))
            done
            LAST_UPDATE_ID=$(( LAST_UPDATE_ID + UNREAD_UPDATES_NUMBER ))
        fi
        sleep 1
    done
else
    echo "Error!"
fi