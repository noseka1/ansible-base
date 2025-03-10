#!/bin/bash -x

# Create a loop device and LVM volume group

device_name=loop0
device_path=/dev/$device_name
data_path=/var/local/${device_name}-device-data.img
data_size=2048G

# Create an empty backing file and LVM volume group
if [ ! -f $data_path ]; then
  truncate --size  $data_size $data_path
  losetup --show $device_path $data_path
  pvcreate $device_path
  vgcreate $device_name-vg $device_path
else
  losetup --show $device_path $data_path
fi

# This triggers LVM auto-activation as a side-effect which is what we want
losetup --set-capacity $device_path

# Install snapshot and thin volume module for lvm.
# If these kernel modules are not avaialable, volume provisioning fails with:
# thin: Required device-mapper target(s) not detected in your kernel.
sudo modprobe dm-snapshot
sudo modprobe dm_thin_pool
