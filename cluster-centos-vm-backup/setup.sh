https://scotch.io/tutorials/how-to-create-a-vagrant-base-box-from-an-existing-one


[ $(vagrant plugin list | grep vagrant-hostmanager | wc -l) != 1 ] && vagrant plugin install vagrant-hostmanager 

[ $(vagrant plugin list | grep vagrant-vbguest | wc -l) != 1 ] && vagrant plugin install vagrant-vbguest

vagrant up

vagrant halt 

vagrant box list

vagrant package --base master.qa.kube.io  --output kube-manager.box

vagrant package --output kube-manager.box

vagrant box add kube-master.box --name kube-manager.box

vagrant box list

--output kube-manager.box
