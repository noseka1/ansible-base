#!/bin/bash
NAME=container-1
IMAGE=ubi8/ubi

podman run \
  --detach \
  --hostname $NAME \
  --name $NAME \
  $IMAGE \
  /bin/bash -c 'yum install sudo --assumeyes && /usr/bin/sleep infinity'
