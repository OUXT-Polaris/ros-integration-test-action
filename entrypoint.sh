#!/bin/sh -l

BASE_IMAGE=$1
TAG=$2

cd /runtime_image

# here we can make the construction of the image as customizable as we need
# and if we need parameterizable values it is a matter of sending them as inputs
docker build -t runtime_image \
    --build-arg base_image="$BASE_IMAGE" \
    --build-arg tag="$TAG" \
    . \
    && docker run runtime_image