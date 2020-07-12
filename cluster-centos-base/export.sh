#https://scotch.io/tutorials/how-to-create-a-vagrant-base-box-from-an-existing-one

vagrant up

vagrant ssh -- -t "sudo sh /vagrant/cleanup.sh"

vagrant halt 

vagrant box list

#vagrant package --output ../../../kubernetes-masterv17.box
vagrant package --output ../../../kubernetes-workerv17.box

#vagrant box add ../../../kubernetes-masterv17.box --name kubernetes-masterv17
vagrant box add ../../../kubernetes-workerv17.box --name kubernetes-workerv17

vagrant box list