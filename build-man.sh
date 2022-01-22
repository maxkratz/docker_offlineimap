#!/bin/bash

set -e

# setup
echo "=> Starting setup."
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
docker buildx rm builder
docker buildx create --name builder --driver docker-container --use
docker buildx inspect --bootstrap

echo "=> Starting builds."

#linux/amd64,linux/arm64,linux/arm/v7

# base image
docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t maxkratz/offlineimap:latest --push .
#--push

echo "=> Build and push finished."
