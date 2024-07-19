#!/bin/bash -x

# Safe configuration
# -e will exit the entire script at the first error.
# -u will exit the entire script if you use an unset variable.
# -o pipefail will fail pipelines if any command, not just the last one, exits with nonzero.
set -euo pipefail

nbd_device=/dev/nbd0

function mount_image {
  local image_path=$1
  local mount_point=$2

  sudo modprobe nbd
  sudo qemu-nbd --connect $nbd_device $image_path

  while [ ! -b ${nbd_device}p1 ]; do
    # qemu-nbd can return before the block device is created by udev
    # see also: https://bugzilla.redhat.com/show_bug.cgi?id=1111635
    echo Waiting for device ${nbd_device}p1 to show up
    sleep 1
  done

  local table_type=dos
  if sudo fdisk --list $nbd_device | grep 'Disklabel type: gpt'; then
    table_type=gpt
  fi
  local partition_offset
  if [ "$table_type" = dos ]; then
    partition_offset=$(sudo fdisk --list --units $nbd_device | grep '83 Linux' | awk '{ print $3 }')
  else
    # Find the offset of the largest partition
    partition_offset=$(
      sudo fdisk --list-details $nbd_device 2>/dev/null |
        grep "^$nbd_device" | sort -n -k 4 | tail -1 | awk '{ print $2 }'
    )
  fi

  local partition_offset_bytes=$((partition_offset * 512))

  echo Mounting image to $mount_point
  sudo mount -o loop,offset=$partition_offset_bytes $nbd_device $mount_point
}

function umount_image {
  local mount_point=$1
  echo Unmounting image from $mount_point
  sudo umount $mount_point
  rmdir $mount_point
  sudo qemu-nbd --disconnect $nbd_device
}

function prepare_chroot {
  local mount_point=$1
  local chroot_point=$2

  sudo mount -t proc none $chroot_point/proc
  sudo mount -t sysfs none $chroot_point/sys
  sudo mount -o bind /dev $chroot_point/dev

  if [ $mount_point != $chroot_point ]; then
    # Bind mount separate /home and /var for Fedora image
    sudo mount --bind $mount_point/home $chroot_point/home
    sudo mount --bind $mount_point/var $chroot_point/var
  fi
}

function tear_down_chroot {
  local mount_point=$1
  local chroot_point=$2

  if [ $mount_point != $chroot_point ]; then
    sudo umount $chroot_point/home
    sudo umount $chroot_point/var
  fi

  sudo umount $chroot_point/proc
  sudo umount $chroot_point/sys
  sudo umount $chroot_point/dev
}


if [ "$#" -gt 0 ]; then
	image_path=$1
else
  echo "Missing parameter <image_path>. <image_path> is not set. It should point to the image file to configure. Exiting ..."
	exit 1
fi

playbook_name=image_vm.yml

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ansible_root="$script_dir/.."

# Mount the image
mount_point=$(mktemp -d -t mount_XXXXXX)
mount_image $image_path $mount_point

# Determine the chroot directory
chroot_point=$mount_point
if [ -d "$mount_point/root/proc" ]; then
  chroot_point=$mount_point/root
fi

prepare_chroot $mount_point $chroot_point

function cleanup_mount {
  tear_down_chroot $mount_point $chroot_point
  umount_image $mount_point
}

trap cleanup_mount EXIT

pushd $ansible_root
sudo \
  --preserve-env \
  ansible-playbook \
    --inventory inventory/localhost.yml \
    --extra-vars "chroot_location=$chroot_point" \
    $playbook_name \
|| exit 1
popd
