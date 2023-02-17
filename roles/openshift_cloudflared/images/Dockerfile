FROM docker.io/fedora:37

RUN curl --location \
  --output /usr/local/bin/cloudflared \
  https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 && \
  chmod 755 /usr/local/bin/cloudflared

RUN mkdir /cloudflared && \
  chgrp root /cloudflared && \
  chmod g+w /cloudflared
