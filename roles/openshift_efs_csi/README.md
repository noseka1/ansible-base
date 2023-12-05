# AWS EFS CSI driver

This role installs the AWS EFS CSI driver to OpenShift. Prior to running this role, you must create an EFS filesystem in AWS as described in [Creating and configuring access to EFS volumes in AWS](https://docs.openshift.com/container-platform/4.14/storage/container_storage_interface/persistent-storage-csi-aws-efs.html). Set the Ansible variable *efs_aws_file_system_id* to the ID ("fs-...") of the newly created file system.
