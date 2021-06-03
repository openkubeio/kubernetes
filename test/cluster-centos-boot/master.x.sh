
echo "--- enable kubelet service"
sudo systemctl enable kubelet

echo "--- Export variables"
HOST_NAME=$(hostname -f)
IPADDR_ENP0S8=$(ifconfig eth1 | grep inet | grep broadcast | awk '{print $2}')

echo "setup node ip in kubelet"
echo "Environment=\"KUBELET_EXTRA_ARGS=--node-ip=$IPADDR_ENP0S8\"" | sudo tee -a /usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf

echo "--- Initialise kubeadm"
sudo kubeadm init  --apiserver-advertise-address=$IPADDR_ENP0S8  --apiserver-cert-extra-sans=$IPADDR_ENP0S8  --node-name $HOST_NAME  --pod-network-cidr 10.10.0.0/16 --service-cidr  10.150.0.0/16  2>&1 | tee -a $data_dir/init_master.log


echo "--- Setup kubectl for vagrant user"
sudo mkdir /root/.kube/
sudo cp /etc/kubernetes/admin.conf /root/.kube/config

echo "--- Implement Calico for Kubernetes Networking"
sudo kubectl apply -f https://docs.projectcalico.org/v3.11/manifests/calico.yaml

echo "--- Waiting for core dns pods to be up . . . "
while [ $(sudo kubectl get pods --all-namespaces | grep dns | grep Running | wc -l) != 2 ] ; do sleep 20 ; echo "--- Waiting for core dns pods to be up . . . " ; done

while [ $(sudo kubectl get nodes | grep master | grep Ready | wc -l) != 1 ] ; do sleep 20 ; echo "--- Waiting node to be ready . . . " ; done
echo "--- Matser node is Ready"
sudo kubectl get nodes

#echo "--- create dummy bootstart if not exist"
#[ -f /etc/kubernetes/bootstrap-kubelet.conf ] || sudo touch /etc/kubernetes/bootstrap-kubelet.conf

echo "--- Copy kube config to shared kubeadm install path"
sudo cp /etc/kubernetes/admin.conf $data_dir/config

echo "--- Export token for Worker Node"
sudo kubeadm token create --print-join-command > $data_dir/kubeadm_join_cmd.sh

