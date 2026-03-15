# Node Observability Operator

Shell script that downloads the generated performance profiles:

```
oc get nodeobservabilityrun example -o jsonpath='{range .status.agents[*]}{.name}{"\n"}' | while read agent; do
  if [ -n "$agent" ]; then
    echo $agent
    oc exec $agent -c node-observability-agent -- bash -c 'ls /run/node-observability/*.pprof' | while read profile; do
      echo $profile
      oc exec $agent -c node-observability-agent -- cat $profile > $(basename $profile)
    done
  fi
done
```

## References

* [Requesting CRI-O and Kubelet profiling data by using the Node Observability Operator](https://docs.openshift.com/container-platform/4.13/scalability_and_performance/node-observability-operator.html)
* [NodeObservability Operator](https://github.com/openshift/node-observability-operator)
