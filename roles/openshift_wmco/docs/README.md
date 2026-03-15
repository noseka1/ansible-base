# Windows Machine Config Operator (WMCO)

WMCO requires hybrid networking to be enabled. The Ansible role will configure the OVN-Kubernetes hybrid network overlay:

```
$ oc patch networks.operator.openshift.io cluster --type merge \
  -p '
    spec:
      defaultNetwork:
        ovnKubernetesConfig:
          hybridOverlayConfig:
            hybridClusterNetwork:
            - cidr: 10.132.0.0/14
              hostPrefix: 23
            hybridOverlayVXLANPort: 9898
  '

See also [Configuring hybrid networking](https://docs.redhat.com/en/documentation/openshift_container_platform/4.18/html-single/networking/index#configuring-hybrid-networking)

Note that Windows nodes use a cluster-wide proxy configuration when making external requests outside the cluster’s internal network, for example when downloading images from container registries. See also [Using Windows containers in a proxy-enabled cluster](https://docs.redhat.com/en/documentation/openshift_container_platform/4.18/html/windows_container_support_for_openshift/enabling-windows-container-workloads#wmco-cluster-wide-proxy_enabling-windows-container-workloads)

## References

* [Supported Windows Server versions](https://docs.redhat.com/en/documentation/openshift_container_platform/4.18/html/windows_container_support_for_openshift/release-notes#wmco-prerequisites-supported-10.18.0_windows-containers-release-notes-10-18-x-prereqs)
* [Windows in Kubernetes](https://kubernetes.io/docs/concepts/windows/)
