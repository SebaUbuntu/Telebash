#!/bin/bash
#
# Copyright (C) 2021 Telebash
#
# SPDX-License-Identifier: Apache-2.0
#

import_modules() {
	for module in $(ls modules/*/main.sh); do
		source "${module}"
	done

	for module_commands_file in $(ls modules/*/commands.txt); do
		for commands in $(cat "${module_commands_file}"); do
			export AVAILABLE_COMMANDS="${AVAILABLE_COMMANDS} ${commands}"
		done
	done
}

execute_module() {
	local MESSAGE_TEXT="$(tg_get_message_text "$@")"
	if [[ "${MESSAGE_TEXT}" == /* ]]; then
		local MESSAGE_TEXT="${MESSAGE_TEXT#?}"
		local MESSAGE_TEXT_COMMAND=$(echo "${MESSAGE_TEXT}" | head -n1 | awk '{print $1;}')
		if echo "${MESSAGE_TEXT_COMMAND}" | grep -q "@"; then
			local MESSAGE_TEXT_BOT=$(echo "${MESSAGE_TEXT_COMMAND}" | cut -d'@' -f2)
			local MESSAGE_TEXT_COMMAND=$(echo "${MESSAGE_TEXT_COMMAND}" | cut -d'@' -f1)
		else
			local MESSAGE_TEXT_BOT="$(tg_get_bot_username)"
		fi
		if [ "${MESSAGE_TEXT_BOT}" = "$(tg_get_bot_username)" ]; then
			if echo "${AVAILABLE_COMMANDS}" | grep -q "${MESSAGE_TEXT_COMMAND}"; then
				"module_${MESSAGE_TEXT_COMMAND}" "$@"
			fi
		fi
	fi
}
