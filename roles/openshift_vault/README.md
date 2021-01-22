# 

This role deploys HashiCorp Vault to OpenShift. The deployed instance is suitable for testing/development purposes only. **It should in no way be used in production environments!**

The Vault documentation is avaialable [here](https://learn.hashicorp.com/vault).

The role performs the following configuration:

* Deploy Vault on OpenShift using the official HashiCorp Helm Chart
* Create an external Route to reach Vault from outside of the OpenShift cluster
* Enable Vault Web UI
* Initialize Vault and unseal it. The unseal key is stored as a Kubernetes Secret, allowing to unseal Vault be re-running the Ansible playbook.
* Enable Usename & Password authentication method
* Enable Kubernetes authentication method
* Create an *admin* user with unlimited privileges
* Enable audit logs
* Insert test secrets in Vault
