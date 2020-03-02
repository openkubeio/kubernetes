[ $(vagrant plugin list | grep vagrant-hostmanager | wc -l) != 1 ] && vagrant plugin install vagrant-hostmanager 
[ $(vagrant plugin list | grep vagrant-vbguest | wc -l) != 1 ] && vagrant plugin install vagrant-vbguest
vagrat up
cp ../data/cluster-centos7/config ~/.kube/
kubectl label node worker1.qa.kube.io  node-role.kubernetes.io/worker=worker
kubectl label node worker2.qa.kube.io  node-role.kubernetes.io/worker=worker
kubectl get nodes




