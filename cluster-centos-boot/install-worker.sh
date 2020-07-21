
#echo "--- enable kubelet service"
sudo systemctl enable kubelet

echo "--- Join as worker node "
sudo chmod +x /data/$cluster/kubeadm_join_cmd.sh
sudo sh /data/$cluster/kubeadm_join_cmd.sh

#echo "--- create dummy bootstart if not exist"
#[ -f /etc/kubernetes/bootstrap-kubelet.conf ] || sudo touch /etc/kubernetes/bootstrap-kubelet.conf
