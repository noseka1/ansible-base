#!/bin/bash

set -euo pipefail

if [ "$#" -gt 0 ]; then
	vmware_hostname=$1
else
  echo Missing parameter VMWARE_HOSTNAME
	exit 1
fi

openssl s_client \
    -connect $vmware_hostname:443 \
    < /dev/null 2>/dev/null \
    | openssl x509 -fingerprint -noout -in /dev/stdin \
    | cut -d '=' -f 2
