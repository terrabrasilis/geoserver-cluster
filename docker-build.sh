#!/bin/bash

VERSION=$(cat PROJECT_VERSION | grep -oP '(?<="version": ")[^"]*')
export VERSION
GS_BASE_VERSION=$(cat PROJECT_VERSION | grep -oP '(?<="gs_base_version": ")[^"]*')
export GS_BASE_VERSION
GS_PATCH_VERSION=$(cat PROJECT_VERSION | grep -oP '(?<="gs_patch_version": ")[^"]*')
export GS_PATCH_VERSION

docker build --no-cache -t terrabrasilis/geoserver-broker:v$VERSION \
--build-arg GS_BASE_VERSION=$GS_BASE_VERSION BrokerActiveMQ/

# build all images
docker build --no-cache -t terrabrasilis/geoserver-master:v$VERSION \
--build-arg BUILD_TYPE=master --build-arg VERSION=$VERSION \
--build-arg GS_BASE_VERSION=$GS_BASE_VERSION --build-arg GS_PATCH_VERSION=$GS_PATCH_VERSION \
GeoServerDocker/

docker build --no-cache -t terrabrasilis/geoserver-worker:v$VERSION \
--build-arg BUILD_TYPE=slave --build-arg VERSION=$VERSION \
--build-arg GS_BASE_VERSION=$GS_BASE_VERSION --build-arg GS_PATCH_VERSION=$GS_PATCH_VERSION \
GeoServerDocker/

# send to dockerhub
## docker login
docker push terrabrasilis/geoserver-broker:v$VERSION
docker push terrabrasilis/geoserver-master:v$VERSION
docker push terrabrasilis/geoserver-worker:v$VERSION
