[ $(vagrant plugin list | grep vagrant-hostmanager | wc -l) != 1 ] && vagrant plugin install vagrant-hostmanager 
[ $(vagrant plugin list | grep vagrant-vbguest | wc -l) != 1 ] && vagrant plugin install vagrant-vbguest
vagrant up
vagrant ssh master.dv.kube.io -- -t "sudo sed -i '/ swap /s/^\(.*\)$/#\1/g' /etc/fstab; sudo sed -i  's/--bootstrap-kubeconfig=\/etc\/kubernetes\/bootstrap-kubelet.conf//'  \/etc\/systemd\/system\/kubelet.service.d\/10-kubeadm.conf"
vagrant ssh worker1.dv.kube.io -- -t "sudo sed -i '/ swap /s/^\(.*\)$/#\1/g' /etc/fstab; sudo sed -i  's/--bootstrap-kubeconfig=\/etc\/kubernetes\/bootstrap-kubelet.conf//'  \/etc\/systemd\/system\/kubelet.service.d\/10-kubeadm.conf"
vagrant ssh worker2.dv.kube.io -- -t "sudo sed -i '/ swap /s/^\(.*\)$/#\1/g' /etc/fstab; sudo sed -i  's/--bootstrap-kubeconfig=\/etc\/kubernetes\/bootstrap-kubelet.conf//'  \/etc\/systemd\/system\/kubelet.service.d\/10-kubeadm.conf"
vagrant ssh proxy.dv.kube.io -- -t "sudo sed -i '/ swap /s/^\(.*\)$/#\1/g' /etc/fstab; sudo sed -i  's/--bootstrap-kubeconfig=\/etc\/kubernetes\/bootstrap-kubelet.conf//'  \/etc\/systemd\/system\/kubelet.service.d\/10-kubeadm.conf"
cp ../data/cluster-ubuntu/config ~/.kube/
kubectl label node worker1  node-role.kubernetes.io/worker=worker
kubectl label node worker2  node-role.kubernetes.io/worker=worker
kubectl label node proxy    node-role.kubernetes.io/proxy=proxy
kubectl get nodes