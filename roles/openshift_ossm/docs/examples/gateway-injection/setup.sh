#!/bin/bash

set -euo pipefail

cd ./istio-ingress-gateway

if [ ! -f testapp-tls.key ]; then
  openssl req -newkey rsa:2048 -nodes -keyout testapp-tls.key -x509 -out testapp-tls.crt -subj "/CN=testapp-https.example.com"
fi
