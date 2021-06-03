
echo "--- Disable Swap "
sudo swapoff -a
sudo sed -i  '/ swap / s~^~#~g' /etc/fstab


echo "--- Update Kube Config file to update cgroup driver"
echo "Environment=\"cgroup-driver=systemd\"" | sudo tee -a /usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf


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
#sudo sysctl net.bridge.bridge-nf-call-iptables
#echo "cat /usr/lib/sysctl.d/00-system.conf"
echo "net.bridge.bridge-nf-call-iptables = 1" | sudo tee -a /etc/sysctl.conf
sudo sysctl --system


echo "--- facilitate Virtual Extensible LAN (VxLAN) "
sudo modprobe br_netfilter

