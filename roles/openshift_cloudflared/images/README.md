# Custom cloudflared image

Build the custom cloudflared image:

```
$ podman build --tag cloudflared-custom:latest .
```

Upload the built image to a container registry (replace the target regitry with your location):

```
$ podman push cloudflared-custom:latest quay.io/noseka1/cloudflared-custom:latest
```
