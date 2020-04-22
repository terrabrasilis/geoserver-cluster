#!/bin/bash
source ./set-env-vars.sh

push_image()
{
  IMAGE_NAME=terrabrasilis/geoserver-$1:v$VERSION
  if test ! -z "$(docker images -q $IMAGE_NAME)"; then
    echo "Found the image $IMAGE_NAME"
    echo "Do you want sending this new image to Docker HUB? Type yes to continue." ; read SEND_TO_HUB
    if [[ ! "$SEND_TO_HUB" = "yes" ]]; then
        echo "Ok, not send the image."
    else
        echo "Nice, sending the image..."
        docker push $IMAGE_NAME
    fi
  else
    echo "The image $IMAGE_NAME was not found."
    echo "--------------------------------------"
    echo ""
  fi
}

# send to dockerhub
if [[ ! "$1" = "" ]]; then
  push_image $1
else
  push_image broker
  push_image master
  push_image worker
fi
