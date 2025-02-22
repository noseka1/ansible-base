# Sysdig image for RHEL 9 (OCP >= 4.13)

Build the container image using:

```
$ podman build --tag sysdig-custom:rhel9 .
```

Upload the built image to a container registry (replace the target regitry with your location):

```
$ podman push sysdig-custom:rhel9 quay.io/noseka1/sysdig-custom:rhel9
```
