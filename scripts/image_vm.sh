#!/bin/bash
# exit immediately if a command exits with a non-zero status.
set -e

NBD_DEVICE=/dev/nbd3

function mount_image {
  local IMAGE_PATH=$1
  local MOUNT_POINT=$2

  sudo modprobe nbd
  sudo qemu-nbd --connect $NBD_DEVICE $IMAGE_PATH

  local PARTITION_OFFSET=$(sudo fdisk -l -u $NBD_DEVICE 2>/dev/null | grep '83 \+Linux' | awk '{ print $3 }')
  local PARTITION_OFFSET_BYTES=$((PARTITION_OFFSET * 512))

  echo Mounting image to $MOUNT_POINT
  sudo mount -o loop,offset=$PARTITION_OFFSET_BYTES $NBD_DEVICE $MOUNT_POINT
}

function umount_image {
  local MOUNT_POINT=$1
  echo Unmounting image from $MOUNT_POINT
  sudo umount $MOUNT_POINT
  rmdir $MOUNT_POINT
  sudo qemu-nbd --disconnect $NBD_DEVICE
}

function prepare_chroot {
  local MOUNT_POINT=$1
  sudo mount -t proc none $MOUNT_POINT/proc
  sudo mount -t sysfs none $MOUNT_POINT/sys
  sudo mount -o bind /dev $MOUNT_POINT/dev
}

function tear_down_chroot {
  local MOUNT_POINT=$1
  sudo umount $MOUNT_POINT/proc
  sudo umount $MOUNT_POINT/sys
  sudo umount $MOUNT_POINT/dev
}

if [ -z "$IMAGE_PATH" ]; then
  echo "IMAGE_PATH is not set. It should point to the image file to configure. Exiting ..."
  exit 1
fi

PLAYBOOK_NAME=image_vm.yml

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ANSIBLE_ROOT="$SCRIPT_DIR/.."
MOUNT_POINT=$(mktemp -d -t mount_XXXXXX)

mount_image $IMAGE_PATH $MOUNT_POINT
prepare_chroot $MOUNT_POINT

function cleanup_mount {
  tear_down_chroot $MOUNT_POINT
  umount_image $MOUNT_POINT
}

trap cleanup_mount EXIT

ls $MOUNT_POINT/etc/cloud

pushd $ANSIBLE_ROOT
sudo \
  --preserve-env \
  ansible-playbook \
    --inventory inventory/localhost.ini \
    --extra-vars "chroot_location=$MOUNT_POINT" \
    $PLAYBOOK_NAME \
|| exit 1
popd
