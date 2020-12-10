#-- https://developer.epages.com/blog/tech-stories/how-to-setup-a-ha-kubernetes-cluster-etcd-cluster-with-ssl/
#-- https://github.com/etcd-io/etcd/blob/master/Documentation/op-guide/security.md
#-- http://blog.dixo.net/2015/05/setting-up-a-secure-etcd-cluster/
#-- https://sadique.io/blog/2016/11/11/setting-up-a-secure-etcd-cluster-behind-a-proxy/
#-- http://dockerlabs.collabnix.com/kubernetes/beginners/Install-and-configure-a-multi-master-Kubernetes-cluster-with-kubeadm.html
#-- https://github.com/etcd-io/etcd/issues/9917


Create cluster with internal etcd
recreate token to join as maser 
https://blog.scottlowe.org/2019/07/12/calculating-ca-certificate-hash-for-kubeadm/
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/high-availability/
https://blog.scottlowe.org/2019/08/12/converting-kubernetes-to-ha-control-plane/
https://blog.scottlowe.org/2019/08/12/converting-kubernetes-to-ha-control-plane/

could not connect: x509: certificate signed by unknown authority (possibly because of "x509: invalid signature: parent certificate cannot sign this kind of certificate" while trying to verify candidate authority certificate * ) (prober "ROUND_TRIPPER_SNAPSHOT") 


ETCDCTL_API=3 etcdctl --endpoints=https://192.168.205.51:2379 --cert=/vagrant/cfssl/master1-peer.pem --key=/vagrant/cfssl/master1-peer-key.pem --cacert=/vagrant/cfssl/intermediate_ca.pem member list --write-out=simple


master3 etcd: rejected connection from "192.168.205.51:40634" (error "remote error: tls: bad certificate", ServerName "master3.etc.kube.io")

curl https://192.168.205.51:2379 --cert=/vagrant/cfssl/master1-peer.pem --key=/vagrant/cfssl/master1-peer-key.pem --cacert=/vagrant/cfssl/intermediate_ca.pem

  
openssl s_client -showcerts -connect 192.168.205.51:2379

cfssl gencert \
-ca=ca.pem \
-ca-key=ca-key.pem \
-config=ca-config.json \
-hostname=192.168.205.51,192.168.205.52,192.168.205.53,192.168.205.54,127.0.0.1,kubernetes.default \
-profile=kubernetes kubernetes-csr.json | \
cfssljson -bare kubernetes



[root@master2 anchors]# curl  https://192.168.205.51:2379/health --cert /vagrant/openssl/kubernetes.pem --key /vagrant/openssl/kubernetes-key.
pem
{"health":"true"}[root@master2 anchors]#
[root@master2 anchors]#

error unmarshaling configuration schema.GroupVersionKind{Group:"kubeadm.k8s.io", Version:"v1beta2", Kind:"ClusterConfiguration"}: error unmarshaling JSON: while decoding JSON: json: unknown field "apiServerCertSANs"   


--------------------
Add CA Certificate to CentOS 7 clients’ Trusted Store:
[root@master3 anchors]# pwd
/etc/pki/ca-trust/source/anchors
[root@master3 anchors]# ls -ltr
total 4
-rwxr-xr-x. 1 root root 1363 Mar 23 10:12 ca.pem
[root@master3 anchors]# update-ca-trust
[root@master3 anchors]#                               

[root@master3 anchors]#  ETCDCTL_API=3 etcdctl get /
[root@master3 anchors]#  ETCDCTL_API=3 etcdctl put /msg 'haloo'
OK
[root@master3 anchors]# ETCDCTL_API=3 etcdctl get /msg
/msg
haloo
--------------------

