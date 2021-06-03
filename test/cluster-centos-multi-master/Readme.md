
provision-cento-vm.sh

#--- Login into Proxy Node : 

cd /vagrant/

sudo sed -i 's#\r$##g' *.sh

installing-cfssl-client.sh

installing-kubectl-client.sh

installing-haproxy.sh

generate-certificate-authority.sh

generate-certificate-etcd.sh

cat kubeadm-config.yaml 

#--- Login into each Master Node : 

cd /vagrant/

installing-docker.sh

installing-kubeadm.sh

preconfigure-kubeadm.sh
     
installing-etcd.sh


#--- Initializing  1st Node : 192.168.205.90
sudo kubeadm init --config=/vagrant/kubeadm-config.yaml 

#--- Copying the certificates to two other masters
sudo cp -R  /etc/kubernetes/pki /data/ha/

#--- Remove the apiserver.crt and apiserver.key.
sudo rm -f /data/ha/pki/apiserver.*


#--- Initializing  2st Node : 192.168.205.91
sudo cp -R /data/ha/pki /etc/kubernetes/

#--- Initialize the machine as a master node.
sudo kubeadm init --config=/vagrant/kubeadm-config.yaml


#--- Initializing  3rd Node : 192.168.205.92
sudo cp -R /data/ha/pki /etc/kubernetes/

#--- Initialize the machine as a master node.
sudo kubeadm init --config=/vagrant/kubeadm-config.yaml

#--- Copy admin.config
cp /etc/kubernetes/admin.conf /data/ha/

#--- Configure Kubectl on Proxy Node :

sudo su -

mkdir -p /root/.kube

cp /data/ha/admin.conf /root/.kube/config

kubectl get nodes 

sudo kubectl apply -f https://docs.projectcalico.org/v3.11/manifests/calico.yaml

kubectl get pods -n kube-system

Kubectl get nodes