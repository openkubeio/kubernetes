###   Installing Helm

	$ cd /tmp
	$ curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > install-helm.sh
	$ chmod u+x install-helm.sh
	
	$ ./install-helm.sh
		Output
		helm installed into /usr/local/bin/helm
		Run 'helm init' to configure helm.
		
###	Downloading helm binaries for specific release
	https://github.com/helm/helm/releases

###	For Helm version > 3.0
	helm init
	
###	For Helm version < 3.0
	
	Create the tiller serviceaccount:
	$ kubectl -n kube-system create serviceaccount tiller

	Bind the tiller serviceaccount to the cluster-admin role:
	$ kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
	
	Init helm and install tiller 	
	$ helm init --service-account tiller --wait --debug
	
	Secure Helm
	$ kubectl patch deployment tiller-deploy --namespace=kube-system --type=json --patch='[{"op": "add", "path": "/spec/template/spec/containers/0/command", "value": ["/tiller", "--listen=localhost:44134"]}]'
	
	
###	Initialize helm on remote machine, client only
	$ helm init --client-only 
	$ helm version
	

###	Helm setup
	$ helm repo add stable https://kubernetes-charts.storage.googleapis.com/
	$ helm install --name my-tomcat --namespace dev stable/tomcat
	$ helm delete my-release
	

###	Using Helm chart offline
	$ helm pull <chart name>
	$ ls -ltr
	$ helm install --name my-release --namespace dev  <chart name>.tgz

	$ helm pull stable/mysql
	$ ls #  mysql-1.6.3.tgz
	$ helm install mysql  mysql-1.6.3.tgz
	
###	Read Reference

####  Setup Helm
>https://zero-to-jupyterhub.readthedocs.io/en/stable/setup-helm.html

####  Secure Helm 
>https://engineering.bitnami.com/articles/helm-security.html
