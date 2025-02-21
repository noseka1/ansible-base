# Windows Machine Config Operator (WMCO)

WMCO requires hybrid networking to be enabled. You can configure OVN-Kubernetes hybrid network ovarlay using the following command:

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

See also [Configuring hybrid networking](https://docs.openshift.com/container-platform/4.13/networking/ovn_kubernetes_network_provider/configuring-hybrid-networking.html).
