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

# Arguments: <file_path> <destination_dirs>
ci_upload() {
	local FILE_PATH="$1"
	[ ! -f "$FILE_PATH" ] && return 2
	shift
	local DESTINATION_DIRS="$@"
	for dir in $DESTINATION_DIRS; do
		[ "$FULL_DESTINATION_DIR" = "" ] && local FULL_DESTINATION_DIR="$dir" || local FULL_DESTINATION_DIR="${FULL_DESTINATION_DIR}/${dir}"
	done
	if [ "$CI_ARTIFACTS_UPLOAD_METHOD" = gdrive ]; then
		gupload "$FILE_PATH" | grep "https://drive.google.com/open?id=" | sed "s/[][]//g" | tr -d '[:space:]'
	elif [ "$CI_ARTIFACTS_UPLOAD_METHOD" = mega ]; then
		mega-put "$FILE_PATH" "/$FULL_DESTINATION_DIR" > /dev/null 2>&1 && mega-export -a "/$FULL_DESTINATION_DIR/$(basename $FILE_PATH)" | awk '{print $3}'
	elif [ "$CI_ARTIFACTS_UPLOAD_METHOD" = sourceforge ]; then
		for dir in $DESTINATION_DIRS; do
			sshpass -p $CI_SF_PASS sftp -oBatchMode=no $CI_SF_USER@frs.sourceforge.net:/home/frs/project/$CI_SF_PROJECT/$FULL_DESTINATION_DIR > /dev/null 2>&1 <<EOF
mkdir $dir
exit
EOF
			[ "$SF_DESTINATION_DIR" = "" ] && local SF_DESTINATION_DIR="$dir" || local SF_DESTINATION_DIR="${SF_DESTINATION_DIR}/${dir}"
		done
		sshpass -p $CI_SF_PASS sftp -oBatchMode=no $CI_SF_USER@frs.sourceforge.net:/home/frs/project/$CI_SF_PROJECT/$FULL_DESTINATION_DIR > /dev/null 2>&1 <<EOF
put $FILE_PATH
exit
EOF
		# Pass download link to the CI project script
		echo "https://sourceforge.net/projects/$CI_SF_PROJECT/files/$FULL_DESTINATION_DIR/$(basename "$FILE_PATH")/download"
	elif [ "$CI_ARTIFACTS_UPLOAD_METHOD" = "localcopy" ]; then
		mkdir -p "$CI_LOCAL_COPY_DIR/$FULL_DESTINATION_DIR"
		cp "$FILE_PATH" "$CI_LOCAL_COPY_DIR/$FULL_DESTINATION_DIR"
	fi
}

ci_name() {
	if [ "$CI_ARTIFACTS_UPLOAD_METHOD" = "gdrive" ]; then
		printf "Google Drive"
	elif [ "$CI_ARTIFACTS_UPLOAD_METHOD" = "mega" ]; then
		printf "MEGA"
	elif [ "$CI_ARTIFACTS_UPLOAD_METHOD" = "sourceforge" ]; then
		printf "SourceForge"
	elif [ "$CI_ARTIFACTS_UPLOAD_METHOD" = "localcopy" ]; then
		printf "Copy to local directory"
	fi
}
