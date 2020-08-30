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

module_weather() {
	local city="$(tg_get_command_arguments "$@")"
	if [ "$city" = "" ]; then
		tg_send_message --chat_id "$(tg_get_chat_id "$@")" --text "Error: city not specified
Example: /weather New York"  --reply_to_message_id "$(tg_get_message_id "$@")" --parse_mode "Markdown"
		return 1
	fi

	if [ "$WEATHER_TEMP_UNIT" = imperial ]; then
		local temp_unit=F
		local wind_unit=mph
	elif [ "$WEATHER_TEMP_UNIT" = metric ]; then
		local temp_unit=C
		local wind_unit=km/h
	else
		local temp_unit=K
		local wind_unit=km/h
	fi

	local current="$(curl -s -X GET "https://api.openweathermap.org/data/2.5/weather?appid=${WEATHER_API_KEY}&q=${city}&units=${WEATHER_TEMP_UNIT}")"

	if [ "$(echo "$current" | jq .cod | cut -d "\"" -f 2)" != 200 ]; then
		tg_send_message --chat_id "$(tg_get_chat_id "$@")" --text "Error $(echo "$current" | jq .cod | cut -d "\"" -f 2): $(echo "$current" | jq .message | cut -d "\"" -f 2)" --reply_to_message_id "$(tg_get_message_id "$@")" --parse_mode "Markdown"
		return 1
	fi

	local city_name="$(echo "$current" | jq .name | cut -d "\"" -f 2)"
	local city_country="$(echo "$current" | jq .sys.country | cut -d "\"" -f 2)"
	local city_lat="$(echo "$current" | jq .coord.lat)"
	local city_lon="$(echo "$current" | jq .coord.lon)"
	local weather_type="$(echo "$current" | jq '.weather | .[] | .main' | cut -d "\"" -f 2)"
	local weather_type_description="$(echo "$current" | jq '.weather | .[] | .description' | cut -d "\"" -f 2)"
	local temp="$(echo "$current" | jq .main.temp)"
	local temp_min="$(echo "$current" | jq .main.temp_min)"
	local temp_max="$(echo "$current" | jq .main.temp_max)"
	local humidity="$(echo "$current" | jq .main.humidity)"
	local wind_speed="$(echo "$current" | jq .wind.speed)"

	tg_send_message --chat_id "$(tg_get_chat_id "$@")" --text "
Current weather for ${city_name}, ${city_country} (${city_lat}, ${city_lon}):
Weather: ${weather_type} (${weather_type_description})
Temperature: ${temp}${temp_unit} (Min: ${temp_min}${temp_unit} Max: ${temp_max}${temp_unit})
Humidity: ${humidity}%
Wind: ${wind_speed}${wind_unit}
	" --reply_to_message_id "$(tg_get_message_id "$@")" --parse_mode "Markdown"
}
