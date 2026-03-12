# Deploying hosted clusters

## KubeVirt hosted cluster

Prerequisites:

* For KubeVirt hosted cluster, the management OCP cluster must have support for LoadBalancer service. You can for example install MetalLB to get the LoadBalancer service support.
* The DNS entry must exist for `api.<cluster_name>.<base_domain>` pointing to destination where the API Server can be reached. The API Server for the KubeVirt hosted cluster is exposed as a service of type LoadBalancer.

If the hosting cluster doesn't have support for service of type LoadBalancer, the hosted clusters deployment gets stuck early on:

```
$ oc get po -n mycluster20-hosted-mycluster20
```

```
NAME                                     READY   STATUS     RESTARTS   AGE
capi-provider-85bcd6cdc5-r9t5j           0/1     Init:0/1   0          33m
cluster-api-d574d6b7b-v642g              1/1     Running    0          33m
control-plane-operator-76c57b8cf-f66xw   1/1     Running    0          33m
```

References:
* [Create a Kubevirt cluster](https://hypershift-docs.netlify.app/how-to/kubevirt/create-kubevirt-cluster/).
* [Deploying hosted control planes on OpenShift Virtualization](https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/hosted_control_planes/deploying-hosted-control-planes#deploying-hosted-control-planes-on-openshift-virtualization)

## Agent hosted cluster

Prerequisites:

* DNS entries must exist for `api.<cluster_name>.<base_domain>` and `api.<cluster_name>.<base_domain>` pointing to destination where the API Server can be reached. The API Server for the Agent hosted cluster is exposed as a service of type NodePort. DNS entries can be as simple as A records pointing to one of the nodes in the management cluster (i.e. the cluster running the HCP). For example, DNS entry `api.mycluster21.example.com` and `api-int.mycluster21.example.com` pointing to the first master node of the hosting cluster `master1.mycluster5.example.com`.
* DNS entry must exist for `*.apps.<cluster_name>.<base_domain>` pointing to the worker nodes of hosted cluster where the ingress router is deployed.

References:
* [Create an Agent cluster](https://hypershift-docs.netlify.app/how-to/agent/create-agent-cluster/).
* [Deploying hosted control planes on bare metal](https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/hosted_control_planes/deploying-hosted-control-planes#deploying-hosted-control-planes-on-bare-metal)

## References

* [Support matrix for hosted control planes](https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/hosted_control_planes/preparing-to-deploy-hosted-control-planes#hcp-support-matrix_hcp-requirements)
* [Deploying hosted control planes on AWS](https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/hosted_control_planes/deploying-hosted-control-planes#deploying-hosted-control-planes-on-aws)
