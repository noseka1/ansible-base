#!/bin/bash -x

# Create a loop block device that can be used as a storage disk

device_name=loop1
device_path=/dev/$device_name
data_path=/var/local/${device_name}-device-data.img
data_size=2048G

# Create an empty backing file
if [ ! -f $data_path ]; then
  truncate --size  $data_size $data_path
fi

# Initialize the loop device
losetup --show $device_path $data_path

# This triggers LVM auto-activation as a side-effect
losetup --set-capacity $device_path
