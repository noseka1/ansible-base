See also documentation secion [Creating automated etcd backups](https://docs.redhat.com/en/documentation/openshift_container_platform/4.21/html-single/backup_and_restore/index#creating-automated-etcd-backups_backup-etcd).

Note that as of OCP 4.21, the etcd backup feature requires enabling the TechPreviewNoUpgrade feature set on your cluster. Note that enabling the TechPreviewNoUpgradefeature set prevents minor version upgrades. Do not enable this feature on production clusters or you won't be able to upgrade them.
