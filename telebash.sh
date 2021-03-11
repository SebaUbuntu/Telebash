#!/bin/bash
#
# Copyright (C) 2021 Telebash
#
# SPDX-License-Identifier: Apache-2.0
#

export VERSION="2.0.0"
export BRANCH="Stable"

export TELEBASH_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Source variables and basic functions
source "${TELEBASH_DIR}/base/telegram.sh"
source "${TELEBASH_DIR}/variables.sh"

# If we're being sourced, let's stop right here
if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    return
fi

import_modules

if [ "$(telegram getUpdates | jq .ok)" != "true" ]; then
	echo "Error! Make sure you added the right HTTP API token in variables.sh"
	exit 1
fi

echo "Bot up and running!"
while [ 0 != 1 ]; do
	if [ "${LAST_UPDATE_ID}" != "" ]; then
		LAST_UPDATES=$(telegram getUpdates --offset "${LAST_UPDATE_ID}")
	else
		LAST_UPDATES=$(telegram getUpdates)
	fi
	UNREAD_UPDATES_NUMBER="$(tg_get_unread_updates_number "$LAST_UPDATES")"
	if [ "${UNREAD_UPDATES_NUMBER}" != "0" ]; then
		echo "Found ${UNREAD_UPDATES_NUMBER} update(s)"
		CURRENT_UPDATES_NUMBER=0
		while [ "${UNREAD_UPDATES_NUMBER}" -gt "${CURRENT_UPDATES_NUMBER}" ]; do
			execute_module "$(tg_get_specific_update "${LAST_UPDATES}" "${CURRENT_UPDATES_NUMBER}")" &
			CURRENT_UPDATES_NUMBER=$(( CURRENT_UPDATES_NUMBER + 1 ))
		done
		LAST_UPDATE_ID=$(tg_get_last_update_id "${LAST_UPDATES}")
		LAST_UPDATE_ID=$(( LAST_UPDATE_ID + 1 ))
	fi
done
