Steps for the first control plane node 

1. Initialize the control plane:

sudo kubeadm init --control-plane-endpoint "LOAD_BALANCER_DNS:LOAD_BALANCER_PORT" --upload-certs --kubernetes-version 
sudo kubeadm init --control-plane-endpoint "proxy.ha.kube.io:8443" --upload-certs  

sudo kubeadm init --control-plane-endpoint "192.168.100.100:8443" --upload-certs  --apiserver-bind-port 9443

2. Apply the CNI plugin of your choice

kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

3. watch the pods of the control plane

kubectl get pod -n kube-system -w

Steps for the rest of the control plane nodes 

1. Execute the join command that was previously given to you by the kubeadm init output on the first node

sudo kubeadm join 192.168.0.200:6443 --token 9vr73a.a8uxyaju799qwdjv --discovery-token-ca-cert-hash sha256:7c2e69131a36ae2a042a339b33381c6d0d43887e2de83720eff5359e26aec866 --control-plane --certificate-key f8902e114ef118304e561c3ecd4d0b543adc226b7a07f675f56564185ffe0c07

=============================================================================================
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

You can now join any number of the control-plane node running the following command on each as root:

  kubeadm join 192.168.100.100:8443 --token 55v3lj.e48vzajy9scac5o5 \
    --discovery-token-ca-cert-hash sha256:9f317668992f70b0940da7b844832ec0c251d9bbeba28c9ca28d17e3b19447d8 \
    --control-plane --certificate-key 3e752e78cbfaae18d09202c13388a4e4edc70be0fd121a7af1ec35fe2d2dfe6d

Please note that the certificate-key gives access to cluster sensitive data, keep it secret!
As a safeguard, uploaded-certs will be deleted in two hours; If necessary, you can use
"kubeadm init phase upload-certs --upload-certs" to reload certs afterward.

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 192.168.100.100:8443 --token 55v3lj.e48vzajy9scac5o5 \
    --discovery-token-ca-cert-hash sha256:9f317668992f70b0940da7b844832ec0c251d9bbeba28c9ca28d17e3b19447d8
	
=======================================================================================
[root@testnode2 ~]# kubeadm token create --print-join-command
W0806 09:37:50.707136   19697 validation.go:28] Cannot validate kube-proxy config - no validator is available
W0806 09:37:50.707239   19697 validation.go:28] Cannot validate kubelet config - no validator is available
kubeadm join 192.168.100.100:8443 --token 5omals.567bkuxr6oitavsy     --discovery-token-ca-cert-hash sha256:9f317668992f70b0940da7b844832ec0c251d9bbeba28c9ca28d17e3b19447d8
[root@testnode2 ~]#
[root@testnode2 ~]#
[root@testnode2 ~]# kubeadm init phase upload-certs --upload-certs
I0806 09:36:52.259403   18880 version.go:251] remote version is much newer: v1.18.6; falling back to: stable-1.17
W0806 09:36:53.308050   18880 validation.go:28] Cannot validate kube-proxy config - no validator is available
W0806 09:36:53.308087   18880 validation.go:28] Cannot validate kubelet config - no validator is available
[upload-certs] Storing the certificates in Secret "kubeadm-certs" in the "kube-system" Namespace
[upload-certs] Using certificate key:
8cec0a14b51c07e87906bce9ad413ab117e5bd71a8e033c76004beb6d484008c
[root@testnode2 ~]#


kubeadm join 192.168.100.100:8443 --token 5omals.567bkuxr6oitavsy     --discovery-token-ca-cert-hash sha256:9f317668992f70b0940da7b844832ec0c251d9bbeba28c9ca28d17e3b19447d8  --control-plane --certificate-key 8cec0a14b51c07e87906bce9ad413ab117e5bd71a8e033c76004beb6d484008c  --apiserver-bind-port 9443  --apiserver-advertise-address 192.168.100.102

==================================================================================================