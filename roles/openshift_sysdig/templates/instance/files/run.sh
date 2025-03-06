#!/bin/bash

set -e

# To populate the /etc/yum.repos.d/redhat.repo file, run any yum command, for example:
dnf repolist --disablerepo=*

# Install pre-reqs for building the sysdig kernel module
dnf install \
  --releasever 9.4 \
  --enablerepo rhel-9-for-x86_64-baseos-eus-rpms \
  --assumeyes \
  kernel-devel-$(uname -r) \
  elfutils-libelf-devel \
  xz

# Build and insert the kernel module
/usr/bin/scap-driver-loader

echo
echo Press Ctrl-C to exit ...

# Block here
trap : TERM INT
sleep infinity & wait
