#https://scotch.io/tutorials/how-to-create-a-vagrant-base-box-from-an-existing-one

vagrant up

vagrant ssh -- -t "sudo sh /vagrant/cleanup.sh"

vagrant halt 

vagrant box list

vagrant package --output ../../../kubebox-17.box

vagrant box add ../../../kubebox-17.box --name kubebox17

vagrant box list