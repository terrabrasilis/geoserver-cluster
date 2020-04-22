#!/bin/bash
source ./set-env-vars.sh

docker build --no-cache -t terrabrasilis/geoserver-broker:v$VERSION \
--build-arg VERSION=$VERSION \
--build-arg GS_BASE_VERSION=$GS_BASE_VERSION --build-arg GS_PATCH_VERSION=$GS_PATCH_VERSION \
BrokerActiveMQ/
