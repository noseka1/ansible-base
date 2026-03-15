# AWS EFS CSI driver

This Ansible role installs the AWS EFS CSI driver to OpenShift. Before using this role, create an EFS filesystem in AWS as described in [Using Container Storage Interface (CSI)](https://docs.redhat.com/en/documentation/openshift_container_platform/4.19/html/storage/using-container-storage-interface-csi).

Setting up the EFS CSI driver:

1. Create file system in the Elastic File System (EFS) service on AWS. The EFS instance should be created in the same AWS region and VPC as the OpenShift cluster.
2. Check in EFS service which security group the NFS endpoints are protected by (probably the "default" security group).
3. Edit the security group by adding rules allowing access to NFS port 2049 from OpenShift nodes.
