Steps for the first control plane node 

1. Initialize the control plane:

sudo kubeadm init --control-plane-endpoint "LOAD_BALANCER_DNS:LOAD_BALANCER_PORT" --upload-certs --kubernetes-version 
sudo kubeadm init --control-plane-endpoint "proxy.ha.kube.io:6443" --upload-certs 

2. Apply the CNI plugin of your choice

kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

3. watch the pods of the control plane

kubectl get pod -n kube-system -w

Steps for the rest of the control plane nodes 

1. Execute the join command that was previously given to you by the kubeadm init output on the first node

sudo kubeadm join 192.168.0.200:6443 --token 9vr73a.a8uxyaju799qwdjv --discovery-token-ca-cert-hash sha256:7c2e69131a36ae2a042a339b33381c6d0d43887e2de83720eff5359e26aec866 --control-plane --certificate-key f8902e114ef118304e561c3ecd4d0b543adc226b7a07f675f56564185ffe0c07

