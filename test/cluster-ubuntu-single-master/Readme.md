Objective:

	To provision a kuubernetes custer with one master and 2 worker node for development environment.
	
	master node  : master.dv.kube.io	: 2 cpu : 2GB   : ubuntu/xenial
	worker node1 : worker1.dv.kube.io   : 1 cpu : 1GB   : ubuntu/xenial
	worker node2 : worker2.dv.kube.io   : 1 cpu : 1GB   : ubuntu/xenial
	
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

 
