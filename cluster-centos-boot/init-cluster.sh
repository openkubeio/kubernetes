

[ $(vagrant plugin list | grep vagrant-hostmanager | wc -l) != 1 ] && vagrant plugin install vagrant-hostmanager 

[ $(vagrant plugin list | grep vagrant-vbguest | wc -l) != 1 ] && vagrant plugin install vagrant-vbguest

vagrant up

echo "Copying config from cluster"
cp ../data/kubebox17/config ~/.kube/

echo "Labeling the nodes"
kubectl label node worker.st.kube.io  node-role.kubernetes.io=worker
kubectl label node worker2.qa.kube.io  node-role.kubernetes.io=management

echo "validating  the nodes"
kubectl get nodes