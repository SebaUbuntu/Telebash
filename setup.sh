#!/bin/bash
#
# Copyright (C) 2021 Telebash
#
# SPDX-License-Identifier: Apache-2.0
#

# Install dependencies
# Note: if you want to add a package manager, PR it
DEPENDENCIES="bash jq"
if [ "$(command -v apt-get)" != "" ]; then
	sudo apt-get install ${DEPENDENCIES}
elif [ "$(command -v pacman)" != "" ]; then
	sudo pacman -S ${DEPENDENCIES}
else
	echo "Distro not supported, please install the following dependencies by yourself: ${DEPENDENCIES}"
fi

echo "All done!"
