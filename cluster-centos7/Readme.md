Objective:

	To provision a kuubernetes custer with one master and 1 worker node for development environment.
	
	master node1  : master.qa.kube.io	: 2 cpu : 2GB   : centos/7
	worker node2  : worker1.qa.kube.io   : 1 cpu : 1GB   : centos/7
	
	You can change the vm configuration like cpu,memory and OS from servers.yaml as per your requirement. 
	
	Updating cpu and memory can be required if you have to run too many pods. You will see warnings and error in case of insufficinet resouce. Otherwise this configuration is okay for normal develpment and testing.
	
	