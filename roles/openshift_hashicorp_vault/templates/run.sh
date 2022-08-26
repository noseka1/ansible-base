#!/bin/bash
echo VAULT_ADDR is $VAULT_ADDR
while true; do
  status=$(curl \
    --insecure \
    --silent \
    --show-error \
    --location $VAULT_ADDR/v1/sys/seal-status \
    | \
    jq \
    --raw-output \
    '.sealed' \
  )
  if [ "$status" = "true" ]; then
    echo $(date) Vault sealed, unsealing!
    key=$(cat /mnt/key)
    curl \
    --insecure \
    --silent \
    --show-error \
    --location \
    --request PUT \
    --data "{\"key\":\"$key\"}" \
    $VAULT_ADDR/v1/sys/unseal
    echo Unseal returned $?
  fi
  sleep 10
done
