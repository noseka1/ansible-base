#!/bin/bash
while true; do
  oc --insecure-skip-tls-verify=true login \
    --token $(cat /var/run/secrets/kubernetes.io/serviceaccount/token) \
    https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_SERVICE_PORT
  oc --insecure-skip-tls-verify=true get \
    csr -o json | \
    jq -r '.items[] | select(.status == {} ) | .metadata.name' | \
    xargs --no-run-if-empty \
      oc --insecure-skip-tls-verify=true adm certificate approve
  sleep 30
done
