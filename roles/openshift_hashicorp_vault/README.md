# Deploying HashiCorp Vault to OpenShift

This Ansible role deploys [HashiCorp Vault](https://www.vaultproject.io/) to OpenShift.

> The deployed Vault instance is suitable for testing/development purposes only. **It should in no way be used in production environments!**

The Vault documentation is available [here](https://www.vaultproject.io/docs). Useful Vault tutorials can be found [here](https://learn.hashicorp.com/vault). Vault installation on OpenShift using Helm is described in [Vault Installation to Red Hat OpenShift via Helm](https://developer.hashicorp.com/vault/tutorials/kubernetes/kubernetes-openshift).

## Configuration

This Ansible role performs the following configuration:

* Deploy Vault on OpenShift using the official HashiCorp Helm Chart.
* Create an external Route to reach Vault from outside of the OpenShift cluster.
* Enable Vault Web UI.
* Initialize Vault and unseal it. The unseal key is stored as a Kubernetes Secret, allowing to unseal Vault by re-running the Ansible playbook.
* Create an *admin* user with unlimited privileges.
* Enable Usename & Password authentication method.
* Enable Kubernetes authentication method.
* Enable audit logs.
* Create key-value secret store.
* Define Vault roles that grant read access to all secrets to all Kubernetes identities. These roles leave the access to the secrets in Vault wide open. They are used for testing purposes.
* Insert test secrets to Vault.

## Production considerations

* Define secure roles and policies. This Ansible role leaves the access to secrets in Vault wide open.
* Implement a secure unsealing process.
* Scale Vault to multiple replicas.
* Choose a storage backend for Vault. See also [Storage overview](https://www.vaultproject.io/docs/configuration/storage) for the list of available storage options.
* Enable authentication against an Identity Provider like LDAP, Okta, .... See [Auth Methods](https://www.vaultproject.io/docs/auth) for the list of available authentication methods.
