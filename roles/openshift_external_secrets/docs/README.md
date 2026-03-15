# Deploying External Secrets to OpenShift

This Ansible role deploys [External Secrets Operator](https://external-secrets.io/) to OpenShift using an operator. It configures External Secrets to pull secrets data from HashiCorp Vault or AWS Secrets Manager.

If you want to use HashiCorp Vault, you must deploy HashiCorp Vault before deploying External Secrets. Use the [openshift_hashicorp_vault](../openshift_hashicorp_vault) role to deploy HashiCorp Vault.

## References

*  [External Secrets Operator GitHub repo](https://github.com/external-secrets/external-secrets)
