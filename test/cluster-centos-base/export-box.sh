#https://scotch.io/tutorials/how-to-create-a-vagrant-base-box-from-an-existing-one

vagrant up 

vagrant ssh master.qa.kube.io -- -t "sudo sh /cleanup.sh"

vagrant halt 

vagrant box list

vagrant package --base master.qa.kube.io  --output ../../../open-kubeio-v17.3.box
#vagrant package --output ../../../kubernetes-masterv17.box
#vagrant package --output ../../../kubernetes-workerv17.box


vagrant box add ../../../open-kubeio-v17.3.box --name open-kubeio-v17.3
#vagrant box add ../../../kubernetes-masterv17.box --name kubernetes-masterv17
#vagrant box add ../../../kubernetes-workerv17.box --name kubernetes-workerv17

vagrant box list
