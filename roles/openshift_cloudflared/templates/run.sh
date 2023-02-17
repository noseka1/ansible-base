#!/bin/bash -x

set -euo pipefail

export TUNNEL_ORIGIN_CERT=/cloudflared/cert.pem
export TUNNEL_CRED_FILE=/cloudflared/credentials.json

echo Cloudflare tunnel configuration:
echo
cat /cloudflared/config.yaml
echo

# Recreate the hosted Cloudflare tunnel
cloudflared tunnel delete --force $TUNNEL_NAME || true
cloudflared tunnel create $TUNNEL_NAME

# Create a CNAME DNS record in Cloudflare DNS
cloudflared tunnel route dns --overwrite-dns $TUNNEL_NAME $INGRESS_HOSTNAME

# Start the tunnel daemon
cloudflared tunnel --config /cloudflared/config.yaml run
