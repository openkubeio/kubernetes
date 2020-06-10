Login onto masternode and export join token

    Generate token to join as worker node
	$ sudo kubeadm token create --print-join-command > ~/kubeadm_join_cmd.sh

	cat join script
    $ cat ~/kubeadm_join_cmd.sh
      kubeadm join <controlPlaneEndpoint>:6443 --token fybnca.r28yzdafekca00t3     --discovery-token-ca-cert-hash sha256:3c3ac2224e21a325084db2f9bb1aaa31e9f11454f1c1d62826721e6fc5b51a17 

	scp the script to the worker node
    $ scp ~/kubeadm_join_cmd.sh user@worker-node:/home/<user>

Login onto Worker Node and configure

	Install docker
	$ sudo sh docker.sh
	
	Install kubeadm
	$ sudo sh kubeadm.sh

    Preconfig node
	$sudo preconfig.sh

	Join as Worker node
	$ sudo chmod +x ~/kubeadm_join_cmd
    $ sudo sh ~/kubeadm_join_cmd.sh
	
	
