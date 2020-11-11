###   Installing Helm

	$ cd /tmp
	$ curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > install-helm.sh
	$ chmod u+x install-helm.sh
	
	$ ./install-helm.sh
		Output
		helm installed into /usr/local/bin/helm
		Run 'helm init' to configure helm.
		
###	For Downloading binaries for specific release
	https://github.com/helm/helm/releases

 	
#   Installing Tiller

#	Create the tiller serviceaccount:

	$ kubectl -n kube-system create serviceaccount tiller

#	Bind the tiller serviceaccount to the cluster-admin role:

	$ kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
	
#	Installs Tiller on our cluster
	
	$ helm init --service-account tiller --wait
	
#	Secure Helm https://engineering.bitnami.com/articles/helm-security.html
	
	$ kubectl patch deployment tiller-deploy --namespace=kube-system --type=json --patch='[{"op": "add", "path": "/spec/template/spec/containers/0/command", "value": ["/tiller", "--listen=localhost:44134"]}]'
	
#	
#   Using Helm

	$ helm version
	
#	To initialize helm on another machine, you won’t need to setup tiller again
	$ helm init --client-only 
	$ helm version
	
	$ helm repo add stable https://kubernetes-charts.storage.googleapis.com/
    $ helm install --name my-release --namespace dev stable/tomcat
	$ helm delete my-release
	
#   Refer	https://zero-to-jupyterhub.readthedocs.io/en/stable/setup-helm.html


#   Using Helm chart without internet

    $ helm pull <chart name>
    $ ls #The chart will be pulled as a tar to the local directory
    $ helm install <whatever release name you want>  <chart name>.tgz

	$ helm pull stable/mysql
	$ ls #  mysql-1.6.3.tgz
	$ helm install mysql  mysql-1.6.3.tgz


