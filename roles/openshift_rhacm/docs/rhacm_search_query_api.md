# Example of using RHACM Search Query API

The documentation of RHACM Search Query API can be found [here](https://docs.redhat.com/en/documentation/red_hat_advanced_cluster_management_for_kubernetes/2.15/html/apis/apis#search-query-api).

All commands in this tutorial are executed on the RHACM Hub cluster.

First, expose the Search Query API endpoint by creating a route:

```
$ oc create route passthrough -n open-cluster-management --service search-search-api search-api
```

Retrieve the API route host name:
```
$ apihost=$(oc get route -n open-cluster-management search-api -o jsonpath='{.spec.host}')
```

Check that the API route host name was populated correctly, for example:
```
$ echo $apihost
```
```
search-api-open-cluster-management.apps.mycluster5.example.com
```

Retrieve an authentication token from OpenShift:
```
$ apitoken=$(oc whoami --show-token)
```

Create a file with the GraphQL query:
```
$ vi query.json
```

```
{
  "query": "query mySearch($input: [SearchInput]) { searchResult: search(input: $input) { items }}",
  "variables": {
    "input": [
      {
        "keywords": [],
        "filters": [
          {
            "property": "kind",
            "values": [
              "VirtualMachine"
            ]
          }
        ],
        "limit": 10000
      }
    ]
  }
}
```

Execute the query:
```
$ curl -X POST -H 'Content-type: application/json' -H "Authorization: Bearer $apitoken" -d @query.json https://$apihost/searchapi/graphql | jq
```
```
{
  "data": {
    "searchResult": [
      {
          {
            "_hubClusterResource": "true",
            "_specRunStrategy": "Always",
            "_uid": "local-cluster/d0498637-411b-4567-b8c1-0a6ddf23fbf8",
            "agentConnected": "True",
            "apigroup": "kubevirt.io",
            "apiversion": "v1",
            "architecture": "amd64",
            "cluster": "local-cluster",
            "condition": "AgentConnected=True; LiveMigratable=True; Ready=True; StorageLiveMigratable=True",
            "cpu": "2",
            "created": "2026-02-23T20:28:43Z",
            "kind": "VirtualMachine",
            "kind_plural": "virtualmachines",
            "memory": "2147483648",
            "name": "example",
            "namespace": "kubevirt-example",
            "pvcClaimNames": "example-rootdisk",
            "ready": "True",
            "runStrategy": "Always",
            "status": "Running"
          },
          {
            "_hubClusterResource": "true",
            "_specRunStrategy": "Always",
            "_uid": "local-cluster/f8eb6d61-aee6-4e69-a45d-e1e26e27e4af",
            "apigroup": "kubevirt.io",
            "apiversion": "v1",
            "architecture": "amd64",
            "cluster": "local-cluster",
            "condition": "LiveMigratable=True; Ready=False; StorageLiveMigratable=True; Synchronized=False",
            "cpu": "1",
            "created": "2026-02-08T19:50:36Z",
            "flavor": "",
            "kind": "VirtualMachine",
            "kind_plural": "virtualmachines",
            "label": "guestConverted=true; migration=c39ce7ec-b0f7-4f0f-b64d-5da35b57c0d8; plan=0fed5173-e7d6-46de-895e-43cb96cb60dc; resource=vm-config; vmID=vm-33079",
            "memory": "4294967296",
            "name": "haproxy-6q7fp",
            "namespace": "anosek-mig2",
            "osName": "",
            "pvcClaimNames": "myplan2-vm-33079-pbbjs",
            "ready": "False",
            "runStrategy": "Always",
            "status": "Starting",
            "workload": ""
          }
        ]
      }
    ]
  }
}
```

When finished with querying the RHACM database, delete the route that was created at the beginning:
```
$ oc delete route -n open-cluster-management search-api
```
