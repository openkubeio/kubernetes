> **Run pods on all master and worker nodes**

```
kubectl get nodes -o custom-columns=Name:.metadata.name,taint:.spec.taints**

Name         taint
machine-m1   [map[effect:NoSchedule key:node-role.kubernetes.io/master]]
machine-w2   <none>

kubectl apply -f https://github.com/openkubeio/kubernetes/blob/master/02_Scheduling/toleration-all-nodes.yaml
```
---------------------------------------------

> **Run pods on dedicated node only**
```
kubectl taint nodes machine-w2 dedicated=infra:NoSchedule
node/machine-w2 tainted

kubectl get nodes -o custom-columns=Name:.metadata.name,taint:.spec.taints
Name         taint
machine-m1   [map[effect:NoSchedule key:node-role.kubernetes.io/master]]
machine-w2   [map[effect:NoSchedule key:dedicated value:infra]]

kubectl apply -f https://github.com/openkubeio/kubernetes/blob/master/02_Scheduling/toleration-only-infra.yaml
```
---------------------------------------------

> **Run pods on master nodes only**
```
kubectl get nodes -o custom-columns=Name:.metadata.name,taint:.spec.taints
Name         taint
machine-m1   [map[effect:NoSchedule key:node-role.kubernetes.io/master]]
machine-w2   [map[effect:NoSchedule key:dedicated value:infra]]

kubectl apply -f https://github.com/openkubeio/kubernetes/blob/master/02_Scheduling/toleration-only-master.yaml
```
----------------------------------------------

> **Kubernetes doc reference**

https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/

