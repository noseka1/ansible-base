# Example RBAC for OpenShift Virtualization

The example roles grant access to the user groups as follows

* Group developer-view:
  * Read-only access to virtual machines
  * Access to the VNC console of virtual machine
* Group developer-edit:
  * Edit access to virtual machines
  * Ability to live-migrate virtual machines between cluster nodes

## References

* [RBAC roles for storage features in OpenShift Virtualization](https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html-single/virtualization/index#virt-storage-rbac-roles_virt-security-policies)
* [Configuring RBAC permissions for managing VM states by using the web console](https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html/virtualization/managing-vms#virt-configure-rbac-console-subresources-api_virt-controlling-vm-states)
* [Granting live migration permissions](https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html-single/virtualization/index#virt-granting-live-migration-permissions_virt-about-live-migration)
