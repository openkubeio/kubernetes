> **Run pods on all master and worker nodes only**

```
kubectl get nodes --show-labels
NAME         STATUS   ROLES    AGE    VERSION   LABELS
machine-m1   Ready    master   141m   v1.17.0   beta.kubernetes.io/os=linux,kubernetes.io/hostname=machine-m1,kubernetes.io/os=linux,node-role.kubernetes.io/master=
machine-w2   Ready    worker   125m   v1.17.0   beta.kubernetes.io/os=linux,kubernetes.io/hostname=machine-w2,kubernetes.io/os=linux,node-role.kubernetes.io/worker=true
machine-w3   Ready    infra    110m   v1.17.0   beta.kubernetes.io/os=linux,kubernetes.io/hostname=machine-w3,kubernetes.io/os=linux,node-role.kubernetes.io/infra=true


kubectl get nodes -o custom-columns=Name:.metadata.name,taint:.spec.taints
Name         taint
machine-m1   [map[effect:NoSchedule key:node-role.kubernetes.io/master]]
machine-w2   <none>
machine-w3   [map[effect:NoSchedule key:dedicated value:infra]]


kubectl apply -f https://raw.githubusercontent.com/openkubeio/kubernetes/master/02_Scheduling/toleration-all-nodes.yaml
```
---------------------------------------------

> **Run pods on dedicated node only**
```
kubectl get nodes -o custom-columns=Name:.metadata.name,taint:.spec.taints
Name         taint
machine-m1   [map[effect:NoSchedule key:node-role.kubernetes.io/master]]
machine-w2   <none>
machine-w3   [map[effect:NoSchedule key:dedicated value:infra]]


kubectl apply -f https://raw.githubusercontent.com/openkubeio/kubernetes/master/02_Scheduling/toleration-only-infra.yaml
```
---------------------------------------------

> **Run pods on master nodes only**
```
kubectl get nodes -o custom-columns=Name:.metadata.name,taint:.spec.taints
Name         taint
machine-m1   [map[effect:NoSchedule key:node-role.kubernetes.io/master]]
machine-w2   <none>
machine-w3   [map[effect:NoSchedule key:dedicated value:infra]]


kubectl apply -f https://raw.githubusercontent.com/openkubeio/kubernetes/master/02_Scheduling/toleration-only-master.yaml
```
----------------------------------------------

> **Kubernetes doc reference**

https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/

