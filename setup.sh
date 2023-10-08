#!/bin/bash
#
# Copyright (C) 2021 Telebash
#
# SPDX-License-Identifier: Apache-2.0
#

# Install dependencies
# Note: if you want to add a package manager, PR it
DEPENDENCIES="bash jq cowsay neofetch speedtest-cli git"

apt-get -qqy update

COMMON_DEPENDENCIES="bash jq cowsay neofetch openssh sshpass"
APT_DEPENDENCIES="speedtest-cli"
PACMAN_DEPENDENCIES=""
if [ "$(command -v apt-get)" != "" ]; then
	sudo apt-get install ${COMMON_DEPENDENCIES} ${APT_DEPENDENCIES}
	if [ "${PACMAN_DEPENDENCIES}" != "" ]; then
		echo "Note: You must install for yourself the following packages: ${PACMAN_DEPENDENCIES}"
	fi
elif [ "$(command -v pacman)" != "" ]; then
	sudo pacman -S ${COMMON_DEPENDENCIES} ${PACMAN_DEPENDENCIES}
	if [ "${APT_DEPENDENCIES}" != "" ]; then
		echo "Note: You must install for yourself the following packages: ${APT_DEPENDENCIES}"
	fi
else
	echo "Distro not supported, please install the following dependencies by yourself: ${COMMON_DEPENDENCIES} ${APT_DEPENDENCIES} ${PACMAN_DEPENDENCIES}"
fi

apt-get -qqy clean
apt-get -qqy autoremove
# Install labbots/google-drive-upload (be sure to configure it before enabling it with CI variable)
bash <(curl --compressed -s "https://raw.githubusercontent.com/labbots/google-drive-upload/master/install.sh") &> /dev/null
echo "gupload function has been installed, but be sure to configure it before enabling it with CI variable"
echo "For informations, see this https://github.com/labbots/google-drive-upload#generating-oauth-credentials"

# Add SourceForge server to the list of known hosts
[ ! -d ~/.ssh ] && mkdir ~/.ssh
ssh-keyscan frs.sourceforge.net >> ~/.ssh/known_hosts

echo "All done!"
