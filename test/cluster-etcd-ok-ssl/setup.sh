#--- http://dockerlabs.collabnix.com/kubernetes/beginners/Install-and-configure-a-multi-master-Kubernetes-cluster-with-kubeadm.html

sh init-etcd-certificate.sh

sh init-etcd.sh

#--- -- Verify that the cluster is up and running.

sleep 30

ETCDCTL_API=3 etcdctl member list

#---