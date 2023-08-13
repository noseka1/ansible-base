# OpenShift Automated GitOps

To deploy openshift-auto-gitops, log into an OpenShift cluster and run:

```
$ ansible-playbook \
    -i inventory/localhost.yml \
    openshift_gitea_deploy.yml \
    openshift_gitops_deploy.yml \
    openshift_autogitops_deploy.yml
```
