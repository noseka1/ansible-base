# Deploying External Secrets to OpenShift

This Ansible role deploys [External Secrets](https://github.com/external-secrets/kubernetes-external-secrets) to OpenShift using the official Helm Chart. It configures External Secrets to pull secrets data from HashiCorp Vault.

You must to deploy Vault before deploying External Secrets. Use the [openshift_vault](../openshift_vault) role to deploy Vault.
