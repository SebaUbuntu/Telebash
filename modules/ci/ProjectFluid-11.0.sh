#!/bin/bash
#
# Copyright (C) 2021 Telebash
#
# SPDX-License-Identifier: Apache-2.0
#

# This value will also be used for folder name
CI_AOSP_PROJECT=ProjectFluid-11.0
# Name to display on Telegram post
CI_AOSP_PROJECT_NAME="Project Fluid"
# Android version to display on Telegram post
CI_AOSP_PROJECT_VERSION=11
# These next 2 values are needed to lunch (e.g. "lineage"_whyred-"userdebug")
#CI_LUNCH_PREFIX=fluid
CI_LUNCH_SUFFIX=userdebug
# Target to build (e.g. to build a ROM's OTA package, use "bacon" or "otapackage", for a recovery project, use "recoveryimage")
CI_BUILD_TARGET=bacon
# Filename of the output. You can also use wildcards if the name isn't fixed
CI_OUT_ARTIFACTS_NAME=Fluid-*.zip

# Don't touch this line, unless you know what you are doing
modules/ci/AOSP.sh "$@" --project "$CI_AOSP_PROJECT" --name "$CI_AOSP_PROJECT_NAME" --version "$CI_AOSP_PROJECT_VERSION" --lunch_prefix "$CI_LUNCH_PREFIX" --lunch_suffix "$CI_LUNCH_SUFFIX" --build_target "$CI_BUILD_TARGET" --artifacts "$CI_OUT_ARTIFACTS_NAME"
