Objective:

	To provision a kuubernetes custer with one master and 2 worker node for development environment.
	
	master node1  : master.qa.kube.io	: 2 cpu : 2GB   : centos/7
	worker node2 : worker1.qa.kube.io   : 1 cpu : 1GB   : centos/7
	worker node3 : worker2.qa.kube.io   : 1 cpu : 1GB   : centos/7
	proxy  node4 : proxy.qa.kube.io   : 1 cpu : 1GB   : centos/7
	
	See servers.yaml to view node configuraion

Pre-requisites:
    
	
    virtulabox is used for vm provisioning on your machine
    vagrant for automated cluster provisioning.
	
	You must have compatibe version of vagrant and vituabox installled on your machine. 
	You can refer official varant site to downoad and install varant binaries and check compatibility to virtualbox version.
	In this example we have used vagrant version 2.2.6 with Oracle virtuabox 6.0.1.
				
    Install vagrant HostManager Plugin to manage /etc/hosts/
	
	To list of installed plugin
	$ vagrant plugin list
	
	To install HostManager plugin
	$ vagrant plugin install vagrant-hostmanager
	
	To install the Vagrant VB Guest Plugin
	vagrant plugin install vagrant-vbguest 
	
	
	
	
Provision:

	Clone the project
	git clone https://github.com/pramode2009/kubernetes.git
	
	Switch to the cluster folder
	$ cd kubernetes/cluster
	
	To start the cluster provisioning with vagrant 
	$ vagrant up
	
	To ssh to the master node
	$ vagrant ssh master.dv.kube.io
	
	To test you cluster run once you logged into your master node
	$ kubectl get nodes
	
	To destroy the custer
	$ vagrant destroy -f

 
