#!/bin/sh -l

BASE_IMAGE=$1
TAG=$2
ROS_DISTRO=$3
WORKSPACE=$4

cd /runtime_image

# here we can make the construction of the image as customizable as we need
# and if we need parameterizable values it is a matter of sending them as inputs
docker build -t runtime_image \
    --build-arg base_image="$BASE_IMAGE" \
    --build-arg tag="$TAG" \
    --build-arg ros_distro="$ROS_DISTRO" \
    --build-arg workspace="$WORKSPACE" \
    . \
    && docker run runtime_image