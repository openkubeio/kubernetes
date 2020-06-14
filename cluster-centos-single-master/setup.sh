echo "--- Checking vagrant plugin"
[ $(vagrant plugin list | grep vagrant-hostmanager | wc -l) != 1 ] && vagrant plugin install vagrant-hostmanager 
[ $(vagrant plugin list | grep vagrant-vbguest | wc -l) != 1 ] && vagrant plugin install vagrant-vbguest

echo "--- provisioning cluster"
vagrant up

echo "--- Updating service file"
vagrant ssh master.qa.kube.io -- -t "sudo sed -i '/ swap /s/^\(.*\)$/#\1/g' /etc/fstab; sudo sed -i 's/--bootstrap-kubeconfig=\/etc\/kubernetes\/bootstrap-kubelet.conf//' \/usr\/lib\/systemd\/system\/kubelet.service.d\/10-kubeadm.conf"
vagrant ssh worker.qa.kube.io -- -t "sudo sed -i '/ swap /s/^\(.*\)$/#\1/g' /etc/fstab; sudo sed -i 's/--bootstrap-kubeconfig=\/etc\/kubernetes\/bootstrap-kubelet.conf//' \/usr\/lib\/systemd\/system\/kubelet.service.d\/10-kubeadm.conf"
#vagrant ssh worker2.qa.kube.io -- -t "sudo sed -i '/ swap /s/^\(.*\)$/#\1/g' /etc/fstab; sudo sed -i 's/--bootstrap-kubeconfig=\/etc\/kubernetes\/bootstrap-kubelet.conf//' \/usr\/lib\/systemd\/system\/kubelet.service.d\/10-kubeadm.conf"
#vagrant ssh proxy.qa.kube.io -- -t "sudo sed -i '/ swap /s/^\(.*\)$/#\1/g' /etc/fstab; sudo sed -i 's/--bootstrap-kubeconfig=\/etc\/kubernetes\/bootstrap-kubelet.conf//' \/usr\/lib\/systemd\/system\/kubelet.service.d\/10-kubeadm.conf"


echo "Copying config from cluster"
cp ../data/cluster-centos7/config ~/.kube/

echo "Labeling the nodes"
kubectl label node worker1.qa.kube.io  node-role.kubernetes.io=worker
kubectl label node worker.qa.kube.io  node-role.kubernetes.io=worker
kubectl label node worker.qa.kube.io  node-role.kubernetes.io=management

echo "validating  the nodes"
kubectl get nodes
