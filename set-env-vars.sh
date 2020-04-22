#!/bin/bash

VERSION=$(cat PROJECT_VERSION | grep -oP '(?<="version": ")[^"]*')
export VERSION
GS_BASE_VERSION=$(cat PROJECT_VERSION | grep -oP '(?<="gs_base_version": ")[^"]*')
export GS_BASE_VERSION
GS_PATCH_VERSION=$(cat PROJECT_VERSION | grep -oP '(?<="gs_patch_version": ")[^"]*')
export GS_PATCH_VERSION
