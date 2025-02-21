#!/bin/bash

(cat <<EOF
"""Send a reply from the proxy without sending any data to the remote server."""
from mitmproxy import http
from mitmproxy import ctx
import datetime

def request(flow: http.HTTPFlow) -> None:
  ctx.log.info("")
  ctx.log.info(datetime.datetime.now())
  ctx.log.info("")
  flow.response = http.Response.make(200)
EOF
) > http-reply-from-proxy.py

export TERM=screen-256color

mitmdump -s http-reply-from-proxy.py --set flow_detail=4 --set confdir=/home/toolbox
