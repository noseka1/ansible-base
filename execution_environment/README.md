# Execution Environment image for Ansible Automation Platform

Build an execution environment image for Ansible Automation Platform:

```
$ ansible-builder build -f execution-environment.yml -v3 -t ansible-base-ee:latest
```

Upload the built image to a container registry (replace the target registry with your location), for example:

```
$ podman push ansible-base-ee:latest quay.io/noseka1/ansible-base-ee:latest
```
