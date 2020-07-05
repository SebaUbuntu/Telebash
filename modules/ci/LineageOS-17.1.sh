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

# This value will also be used for folder name
CI_AOSP_PROJECT=LineageOS-17.1
# Name to display on Telegram post
CI_AOSP_PROJECT_NAME="LineageOS 17.1"
# Android version to display on Telegram post
CI_AOSP_PROJECT_VERSION=10
# These next 2 values are needed to lunch (e.g. "lineage"_whyred-"userdebug")
CI_LUNCH_PREFIX=lineage
CI_LUNCH_SUFFIX=userdebug
# Target to build (e.g. to build a ROM's OTA package, use "bacon" or "otapackage", for a recovery project, use "recoveryimage")
CI_BUILD_TARGET=bacon
# Filename of the output. You can also use wildcards if the name isn't fixed
CI_OUT_ARTIFACTS_NAME=lineage-*.zip

# Don't touch this line, unless you know what you are doing
modules/ci/AOSP.sh "$@" --project "$CI_AOSP_PROJECT" --name "$CI_AOSP_PROJECT_NAME" --version "$CI_AOSP_PROJECT_VERSION" --lunch_prefix "$CI_LUNCH_PREFIX" --lunch_suffix "$CI_LUNCH_SUFFIX" --build_target "$CI_BUILD_TARGET" --artifacts "$CI_OUT_ARTIFACTS_NAME"