
[ $(vagrant plugin list | grep vagrant-hostmanager | wc -l) != 1 ] && vagrant plugin install vagrant-hostmanager 

[ $(vagrant plugin list | grep vagrant-vbguest | wc -l) != 1 ] && vagrant plugin install vagrant-vbguest

vagrant up

vagrant halt 

vagrant box list

vagrant package --base default  --output ~/centos/7-yumupdated-20.05.26.box

vagrant box add ~/centos/7-yumupdated-20.05.26.box --name centos/7-yumupdated

vagrant box list
