echo "--- preconfig.sh in exection"

echo "--- Disable Swap "
sudo swapoff -a
sudo sed -i '/ swap /s/^\(.*\)$/#\1/g' /etc/fstab

echo "--- Update Kube Config file to removing bootstrap file and cgroup driver"
sudo sed -i 's/--bootstrap-kubeconfig=\/etc\/kubernetes\/bootstrap-kubelet.conf//' /usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf

echo "--- Update Kube Config file to update cgroup driver"
echo "Environment=\"cgroup-driver=systemd\"" | sudo tee -a /usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf

#echo "export Ip addres of host"
#IPADDR_ETH1=$(ifconfig eth1 | grep inet | grep broadcast | awk '{print $2}')

#echo "must verify during install setup"
#echo "Environment=\"KUBELET_EXTRA_ARGS=--node-ip=$IPADDR_ETH1\"" | sudo tee -a /usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf

echo "--- etc/hosts file to comment ip6"
sudo sed -i '/ip6/s/^/#/' /etc/hosts

echo "--- update firewall to allow connection if enabled"
#not required as of now
#sudo firewall-cmd --permanent --add-port=6443/tcp
#sudo firewall-cmd --permanent --add-port=2379-2380/tcp
#sudo firewall-cmd --permanent --add-port=10250/tcp
#sudo firewall-cmd --permanent --add-port=10251/tcp
#sudo firewall-cmd --permanent --add-port=10252/tcp
#sudo firewall-cmd --permanent --add-port=10255/tcp
#sudo firewall-cmd –-reload

echo "--- update bridge-nf-call-iptables"
sudo sysctl net.bridge.bridge-nf-call-iptables

sudo tee -a /etc/sysctl.conf << EOF
 net.bridge.bridge-nf-call-iptables = 1
EOF

sudo sysctl --system

sudo sysctl net.bridge.bridge-nf-call-iptables

echo "--- facilitate Virtual Extensible LAN (VxLAN) "
sudo modprobe br_netfilter