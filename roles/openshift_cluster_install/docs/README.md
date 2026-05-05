# OpenShift Cluster Installation

This role installs OpenShift cluster using the following installation methods
* **AWS IPI**
* **Azure IPI**
* **GCP IPI**
* **VMware IPI**
* **Agent installation.** Agent-based OpenShift cluster installation including orchestration of machines via Redfish.

The role was tested to work with the following [demo.redhat.com](https://demo.redhat.com/) environments:

* **AWS Blank Open Environment.**
* **Azure Subscription Based Blank Open Environment.** Note that Azure Blank Open Environment doesn't work.
* **GCP Blank Open Environment.**
* **VMware Cloud Public Cloud Open Environment.** Make sure that you check the "Enable DNS records for OCP" checkbox.
