Objective:

	To provision a kuubernetes custer with one master and 1 worker node for development environment.
	
	master node1  : master.qa.kube.io	: 2 cpu : 2GB   : centos/7
	worker node2  : worker1.qa.kube.io   : 1 cpu : 1GB   : centos/7
	
	You can change the vm configuration like cpu,memory and OS from servers.yaml as per your requirement. 
	
	Updating cpu and memory can be required if you have to run too many pods. You will see warnings and error in case of insufficinet resouce. Otherwise this configuration is okay for normal develpment and testing.
	
	See servers.yaml to view node configuraion

Pre-requisites:

    Install local tools
    
	To set up your kubernetes cluster you would require to have virtual box installed to spin up new virtual machines and ofcouse vagrant tool would be requied automate cluser provisioning.

	Once you are done installtion of Virtualbox and vagrant you can check the installtion by your  machine. If you have both of these toolset already installed on your machine, you are good to move ahead.
	
	
	Clone this repo
	
	git clone https://ops.dvt.app.com
	
	
	Generate certificate
	
	Steps to be updated. We have to generate certficates before we provision the cluster. During the custer provisioning we will be intalling 2 applications - Traefik and fahesdauth. They would require these certifate to work properly.
	
CLuster Provisioning :

    Provisioning your kubernetes cluster is fairly simple and can be done by a running the provisioning script kubetk.sh. The script not only crates a cluster but does takes care of number of things related to cluster setup and making it usable in a single go.
	
	What the script does on top of provisioning the custer ?
	
	- Cluster provisioning requires two vagrant plugins vagrant-hostmanager and vagrant-vbguest installed beforehand. The script will install these vagrant plugins if they are not pre-installed.
	
	- Provisions the cluster, Ofcourse!
	
	- Once the cluster is ready, you would need kubctl client to connect to the cluster. This script downloads and install kubectl client on your machine.
	
	- Post kubectl client installation, the script configures the client to make it to connect to the local cluster.
	
	- The script also install traefik ingress and fakeDS Auth in the cluster. You can access the traefik and fakeds auth post cluster provisioning is done.
	
	Access Traefik :    https://traefik.lo.com:32076
	Access fakeDSAuth:  https://fakedsauth.locom:32076
	
	
Command to work with custer :
	
	Move to cluster directory
	cd cluster/
	
	To provision your cluster run the below 
	./kubetk.sh cluster-provision
	
	
	You can check th cluster status once provisioning is done
	kubectl get nodes
	
	
	To save the state of your cluster once you are done for the day ! 
	./kubetk.sh cluster-suspend
	

	To resume the cluster once again
	./kubetk.sh cluster-resume
	
	
	To destroy the custer for ever
	$ vagrant destroy -f
	
	
	If you are already faniliar with vagrant commands, you can use then to manage and check these vms directly.


				
 

 
