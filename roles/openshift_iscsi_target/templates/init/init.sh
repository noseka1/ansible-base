#!/bin/bash

lun_dir=/storage
lun_size={{ iscsi_target_volume_size_gb }}G
target_name=iqn.2025-01.com.example.target:0
initiator_name=iqn.2025-01.com.example.initiator:0
target_service_a_ip={{ iscsi_target_service_a_ip }}
target_service_b_ip={{ iscsi_target_service_b_ip }}

echo
echo ***************
echo * Deploy RPMs *
echo ***************
echo

dnf install \
  --assumeyes \
  kmod \
  targetcli

echo
echo **********************
echo * Configuring target *
echo **********************
echo

targetcli /iscsi create $target_name

# Delete the 0.0.0.0 target so that we can create specific IP targets
targetcli /iscsi/$target_name/tpg1/portals delete 0.0.0.0 3260

# Listen on the pod IP, and allow connecting via pod IP
targetcli /iscsi/$target_name/tpg1/portals create $(hostname -i) 3260

# Allow connecting via service A IP
targetcli /iscsi/$target_name/tpg1/portals create $target_service_a_ip 3260
#
# Allow connecting via service B IP
targetcli /iscsi/$target_name/tpg1/portals create $target_service_b_ip 3260

# Create LUNs
for i in $(seq 0 9); do
  targetcli /backstores/fileio create disk0$i $lun_dir/disk0$i.img $lun_size
  targetcli /iscsi/$target_name/tpg1/luns create /backstores/fileio/disk0$i
done

targetcli /iscsi/$target_name/tpg1/acls create $initiator_name

echo
echo ************************
echo * Target configuration *
echo ************************
echo

targetcli ls
