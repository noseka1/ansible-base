#!/bin/bash
while true; do
  oc login \
    --token $(cat /var/run/secrets/kubernetes.io/serviceaccount/token) \
    --certificate-authority /var/run/secrets/kubernetes.io/serviceaccount/ca.crt \
    https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_SERVICE_PORT
  oc get csr -o json | \
    jq -r '.items[] | select(.status == {} ) | .metadata.name' | \
    xargs --no-run-if-empty oc adm certificate approve
  sleep 10
done
