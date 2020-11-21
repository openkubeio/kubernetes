kubectl get nodes -o custom-columns=Name:.metadata.name,taint:.spec.taints

Name         taint
machine-m1   [map[effect:NoSchedule key:node-role.kubernetes.io/master]]
machine-w2   <none>


=========================================================
metadata:
  annotations:
    kubeadm.alpha.kubernetes.io/cri-socket: /var/run/dockershim.sock
    node.alpha.kubernetes.io/ttl: "0"
    projectcalico.org/IPv4Address: 192.168.210.10/24
    projectcalico.org/IPv4IPIPTunnelAddr: 192.168.191.192
    volumes.kubernetes.io/controller-managed-attach-detach: "true"
  creationTimestamp: "2020-11-11T05:54:59Z"
  labels:
    beta.kubernetes.io/arch: amd64
    beta.kubernetes.io/os: linux
    kubernetes.io/arch: amd64
    kubernetes.io/hostname: machine-m1
    kubernetes.io/os: linux
    node-role.kubernetes.io/master: ""
  name: machine-m1
  resourceVersion: "148422"
  selfLink: /api/v1/nodes/machine-m1
  uid: b7650ae0-2327-4279-9878-2c2fcf3394a3
spec:
  podCIDR: 10.10.0.0/24
  podCIDRs:
  - 10.10.0.0/24
  taints:
  - effect: NoSchedule
    key: node-role.kubernetes.io/master

========================================================

Name:               machine-w2
Roles:              worker
Labels:             beta.kubernetes.io/arch=amd64
                    beta.kubernetes.io/os=linux
                    kubernetes.io/arch=amd64
                    kubernetes.io/hostname=machine-w2
                    kubernetes.io/os=linux
                    node-role.kubernetes.io/worker=worker
Annotations:        kubeadm.alpha.kubernetes.io/cri-socket: /var/run/dockershim.sock
                    node.alpha.kubernetes.io/ttl: 0
                    projectcalico.org/IPv4Address: 192.168.210.11/24
                    projectcalico.org/IPv4IPIPTunnelAddr: 192.168.49.192
                    volumes.kubernetes.io/controller-managed-attach-detach: true
Taints:             <none>
Unschedulable:      false

=========================================================

