# Deploying External Secrets to OpenShift

This Ansible role deploys [External Secrets](https://github.com/external-secrets/external-secrets) to OpenShift using an operator. It configures External Secrets to pull secrets data from HashiCorp Vault or AWS Secrets Manager.

If you want to use HashiCorp Vault, you must deploy HashiCorp Vault before deploying External Secrets. Use the [hashicorp_vault](../hashicorp_vault) role to deploy HashiCorp Vault.
