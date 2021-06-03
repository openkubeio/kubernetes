#--- cluster-etcd-no-ssl

#--- Reference journal
#--- https://computingforgeeks.com/setup-etcd-cluster-on-centos-debian-ubuntu/

sh init-etcd.sh

sh init-etcd-test.sh

#--- -- Verify that the cluster is up and running.

sudo etcdctl member list

sudo etcdctl cluster-health

#--- -- To use etcd v3, you need to explicitly specify version

ETCDCTL_API=3 etcdctl member list

#--- -- Test by writing to etcd

etcdctl set /message "Hello World"

etcdctl get /message
