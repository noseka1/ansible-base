#!/bin/bash -x

# Install additional RPM packages

# `--allow-inactive` ensures that rpm-ostree does not return an error
# if the package is already installed. This is useful if the package is
# added to the root image in a future RH CoreOS release as it will
# prevent the service from failing.

sudo rpm-ostree install \
  --allow-inactive \
  --idempotent \
  --reboot \
  iotop \
  kernel-debuginfo \
  lsof \
  perf \
  python3-six \
  setools-console \
  setroubleshoot-server \
  tcpdump \
  vim \
  wireshark-cli \
  2>&1
