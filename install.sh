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

# Install dependencies
# Note: if you want to add a package manager, PR it
COMMON_DEPENDENCIES="bash jq cowsay neofetch"
APT_DEPENDENCIES="speedtest-cli"
PACMAN_DEPENDENCIES=""
if [ "$(command -v apt-get)" != "" ]; then
	sudo apt-get install $COMMON_DEPENDENCIES $APT_DEPENDENCIES
	if [ "$PACMAN_DEPENDENCIES" != "" ]; then
		echo "Note: You must install for yourself the following packages: $PACMAN_DEPENDENCIES"
	fi
elif [ "$(command -v pacman)" != "" ]; then
	sudo pacman -S $COMMON_DEPENDENCIES $PACMAN_DEPENDENCIES
	if [ "$APT_DEPENDENCIES" != "" ]; then
		echo "Note: You must install for yourself the following packages: $APT_DEPENDENCIES"
	fi
else
	echo "Distro not supported, please install the following dependencies by yourself: $COMMON_DEPENDENCIES $APT_DEPENDENCIES $PACMAN_DEPENDENCIES"
fi

# Install labbots/google-drive-upload (be sure to configure it before enabling it with CI variable)
bash <(curl --compressed -s https://raw.githubusercontent.com/labbots/google-drive-upload/master/install.sh) > /dev/null 2>&1
echo "gupload function has been installed, but be sure to configure it before enabling it with CI variable"
echo "For informations, see this https://github.com/labbots/google-drive-upload#generating-oauth-credentials"
echo "All done!"