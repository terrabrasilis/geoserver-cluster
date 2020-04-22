#!/bin/bash
source ./set-env-vars.sh

build_image()
{
  TYPE=$1
  IMAGE_NAME=terrabrasilis/geoserver-$TYPE:v$VERSION
  if test ! -z "$(docker images -q $IMAGE_NAME)"; then
    echo "The image $IMAGE_NAME exist."
    echo "Do you want override that? Type yes to continue." ; read REBUILD_IMG
    if [[ ! "$REBUILD_IMG" = "yes" ]]; then
      echo "Ok, aborting."
      exit
    else
      echo "I will build on what exists ..."
    fi
  else
    echo "The image $IMAGE_NAME no exist yet, building ..."
  fi
  
  docker build --no-cache -t terrabrasilis/geoserver-$TYPE:v$VERSION \
  --build-arg BUILD_TYPE=$TYPE --build-arg VERSION=$VERSION \
  --build-arg GS_BASE_VERSION=$GS_BASE_VERSION --build-arg GS_PATCH_VERSION=$GS_PATCH_VERSION \
  GeoServerDocker/
  
  echo "The building was finished!"
  ./push-images.sh $TYPE
}

DEFAULT_TYPE="master"
if [[ "$1" = "$DEFAULT_TYPE" ]]; then
  TYPE=$DEFAULT_TYPE
else
  TYPE="worker"
fi

echo "Build the $TYPE GeoServer image with version $VERSION"
build_image $TYPE