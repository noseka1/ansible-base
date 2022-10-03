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
  kernel-debuginfo \
  perf \
  vim \
  lsof \
  tcpdump \
  wireshark-cli \
  setroubleshoot-server \
  setools-console
