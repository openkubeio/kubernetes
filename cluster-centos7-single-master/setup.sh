[ $(vagrant plugin list | grep vagrant-hostmanager | wc -l) != 1 ] && vagrant plugin install vagrant-hostmanager 
[ $(vagrant plugin list | grep vagrant-vbguest | wc -l) != 1 ] && vagrant plugin install vagrant-vbguest

vagrat up

vagrant ssh master.qa.kube.io -- -t "sudo sed -i '/ swap /s/^\(.*\)$/#\1/g' /etc/fstab; sudo sed -i 's/--bootstrap-kubeconfig=\/etc\/kubernetes\/bootstrap-kubelet.conf//' \/usr\/lib\/systemd\/system\/kubelet.service.d\/10-kubeadm.conf"
vagrant ssh worker1.qa.kube.io -- -t "sudo sed -i '/ swap /s/^\(.*\)$/#\1/g' /etc/fstab; sudo sed -i 's/--bootstrap-kubeconfig=\/etc\/kubernetes\/bootstrap-kubelet.conf//' \/usr\/lib\/systemd\/system\/kubelet.service.d\/10-kubeadm.conf"
vagrant ssh worker2.qa.kube.io -- -t "sudo sed -i '/ swap /s/^\(.*\)$/#\1/g' /etc/fstab; sudo sed -i 's/--bootstrap-kubeconfig=\/etc\/kubernetes\/bootstrap-kubelet.conf//' \/usr\/lib\/systemd\/system\/kubelet.service.d\/10-kubeadm.conf"

cp ../data/cluster-centos7/config ~/.kube/

kubectl label node worker1.qa.kube.io  node-role.kubernetes.io/worker=worker
kubectl label node worker2.qa.kube.io  node-role.kubernetes.io/worker=worker

kubectl get nodes
