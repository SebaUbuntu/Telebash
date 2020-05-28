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

module_revengeos() {
	if [ "$(tg_get_command_arguments "$@")" != "" ]; then
		DEVICE_CODENAME="$(tg_get_command_arguments "$@")"
		REVENGEOS_GENERIC_JSON="$(curl https://raw.githubusercontent.com/RevengeOS-Devices/official_devices/r10.0/maintainers.json | jq .)"
		REVENGEOS_DEVICE_JSON="$(curl https://raw.githubusercontent.com/RevengeOS-Devices/official_devices/r10.0/$DEVICE_CODENAME/device.json | jq .)"
		if [ "$(echo "$REVENGEOS_GENERIC_JSON" | jq ".$DEVICE_CODENAME")" != "null" ]; then
			REVENGEOS_DEVICE_INFO="RevengeOS Q build for $DEVICE_CODENAME

Name: $(echo "$REVENGEOS_GENERIC_JSON" | jq ".$DEVICE_CODENAME.name" | cut -d "\"" -f 2)
Mantainer: $(echo "$REVENGEOS_GENERIC_JSON" | jq ".$DEVICE_CODENAME.maintainer" | cut -d "\"" -f 2)
Latest version: [$(echo "$REVENGEOS_DEVICE_JSON" | jq ".filename" | cut -d "\"" -f 2)]($(echo "$REVENGEOS_DEVICE_JSON" | jq ".url" | cut -d "\"" -f 2))"
			if [ "$(echo "$REVENGEOS_GENERIC_JSON" | jq ".$DEVICE_CODENAME.xda_thread" | cut -d "\"" -f 2)" != "" ]; then
				REVENGEOS_DEVICE_INFO="$REVENGEOS_DEVICE_INFO
XDA thread: [Here]($(echo "$REVENGEOS_GENERIC_JSON" | jq ".$DEVICE_CODENAME.xda_thread" | cut -d "\"" -f 2))"
			fi
			if [ "$(echo "$REVENGEOS_DEVICE_JSON" | jq ".donate_url" | cut -d "\"" -f 2)" != "" ]; then
				REVENGEOS_DEVICE_INFO="$REVENGEOS_DEVICE_INFO
Donate: [Here]($(echo "$REVENGEOS_DEVICE_JSON" | jq ".donate_url" | cut -d "\"" -f 2))"
			else
				REVENGEOS_DEVICE_INFO="$REVENGEOS_DEVICE_INFO
Donate: [Here](https://paypal.me/lucchetto)"
			fi
			tg_send_message "$(tg_get_chat_id "$@")" "$REVENGEOS_DEVICE_INFO" "$(tg_get_message_id "$@")"
		else
			tg_send_message "$(tg_get_chat_id "$@")" "Error: device codename is not present in RevengeOS official devices list!
Please make sure you wrote it correctly" "$(tg_get_message_id "$@")"
		fi
	else
		tg_send_message "$(tg_get_chat_id "$@")" "Error: please write a device codename!" "$(tg_get_message_id "$@")"
	fi
}