[ $(vagrant plugin list | grep vagrant-hostmanager | wc -l) != 1 ] && vagrant plugin install vagrant-hostmanager 

[ $(vagrant plugin list | grep vagrant-vbguest | wc -l) != 1 ] && vagrant plugin install vagrant-vbguest

vagrant up





