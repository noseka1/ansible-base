#!/bin/bash

oc_command="oc \
  --server https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_SERVICE_PORT \
  --insecure-skip-tls-verify=true \
  --token $(cat /var/run/secrets/kubernetes.io/serviceaccount/token)"

while true; do
  $oc_command \
    get csr --output json \
    | \
    jq -r '.items[] | select(.status == {} ) | .metadata.name' | \
    xargs --no-run-if-empty \
      $oc_command \
        adm certificate approve
  sleep 30
done
