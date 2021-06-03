echo "--- Executing script nfs-server"

echo "--- Install nfs common package for Storage"
sudo yum install nfs-utils -y 

sudo chkconfig nfs on
sudo service rpcbind start
sudo service nfs start
sudo service nfslock start

sudo systemctl status nfs

echo "--- Create nfs shared directory"
sudo mkdir /nfs/kubedata -p

echo "--- Change owernship"
sudo chown nobody:nobody /nfs/kubedata

echo "--- Update exports file"
sudo tee -a /etc/exports << EOF
/nfs/kubedata  *(rw,sync,no_subtree_check,no_root_squash,no_all_squash,insecure)
EOF

sudo exportfs -a
sudo exportfs -rva

echo "--- Restar nfs server and check status"
sudo systemctl restart nfs
sudo systemctl status nfs