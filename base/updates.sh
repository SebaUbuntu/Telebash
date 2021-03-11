#!/bin/bash
#
# Copyright (C) 2021 Telebash
#
# SPDX-License-Identifier: Apache-2.0
#

# Arguments: <update in JSON>
tg_get_update_result() {
	echo "$@" | jq ".result"
}

# Arguments: <update in JSON>
tg_get_unread_updates() {
	tg_get_update_result "$@" | jq ".[]"
}

# Arguments: <update in JSON>
tg_get_unread_updates_number() {
	tg_get_update_result "$@" | jq "length"
}

# Arguments: <update in JSON> <offset>
tg_get_specific_update() {
	tg_get_update_result "${1}" | jq ".[${2}]"
}

# Arguments: <update in JSON>
tg_get_last_update_id() {
	UPDATE_NUMBER="$(tg_get_unread_updates_number "$@")"
	UPDATE_NUMBER="$(( UPDATES_NUMBER - 1 ))"
	tg_get_specific_update "$@" "${UPDATE_NUMBER}" | jq ".update_id"
}
