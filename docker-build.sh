#!/bin/bash
# build broker image
./docker-build-broker.sh

# build geoserver master and worker images
./docker-build-geoserver.sh master
./docker-build-geoserver.sh worker

echo "The building was finished!"
./push-images.sh
