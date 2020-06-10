echo "--- preconfig.sh"

echo "--- Disable Swap "
sudo swapoff -a
sudo sed -i '/ swap /s/^\(.*\)$/#\1/g' /etc/fstab

echo "--- Update Kube Config file to removing bootstrap file and cgroup driver"
sudo sed -i 's/--bootstrap-kubeconfig=\/etc\/kubernetes\/bootstrap-kubelet.conf//' /usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf

echo "--- Update Kube Config file to update cgroup driver"
echo "Environment=\"cgroup-driver=systemd\"" | sudo tee -a /usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf

echo "export Ip addres of host"
IPADDR_ETH1=$(ifconfig eth1 | grep inet | grep broadcast | awk '{print $2}')

echo "must verify during install setup"
echo "Environment=\"KUBELET_EXTRA_ARGS=--node-ip=$IPADDR_ETH1\"" | sudo tee -a /usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf

echo "--- etc/hosts file to comment ip6"
sudo sed -i '/ip6/s/^/#/' /etc/hosts

echo "--- update bridge-nf-call-iptables"
sudo tee /proc/sys/net/bridge/bridge-nf-call-iptables << EOF
 1
EOF

echo "--- facilitate Virtual Extensible LAN (VxLAN) "
sudo modprobe br_netfilter