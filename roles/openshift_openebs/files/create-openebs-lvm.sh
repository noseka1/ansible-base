#!/bin/bash -x

# Create loop device and LVM volume group

device_name=loop0
device_path=/dev/$device_name
data_path=/var/local/${device_name}-device-data.img
data_size=2048G

if [ ! -f $data_path ]; then
  truncate --size  $data_size $data_path
  losetup --partscan --show $device_path $data_path
  pvcreate $device_path
  vgcreate $device_name-vg $device_path
else
  losetup --partscan $device_path $data_path
fi

# Install snapshot and thin volume module for lvm

sudo modprobe dm-snapshot
sudo modprobe dm_thin_pool
