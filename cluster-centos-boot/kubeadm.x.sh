echo "--- kubeadm.sh in execution" 

echo "--- Update apt respository to stable kubernetes"
sudo tee /etc/yum.repos.d/kubernetes.repo << EOF
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

echo "--- Checking available version of kubeadm"
echo "installing version $(curl -s https://packages.cloud.google.com/apt/dists/kubernetes-xenial/main/binary-amd64/Packages | grep Version | grep 1.17 | awk '{print $2}')"

echo "--- Installing Kubeadm and kubelet - version 1.17.0"
sudo yum install -y kubeadm-1.17.3 kubelet-1.17.3 kubectl-1.17.3 

echo "--- verifying kubelet version "
sudo kubelet --version

echo "--- verifying kubeadm version "
sudo kubeadm version

echo "--- enable kubelet service"
sudo systemctl disable kubelet
