
#--- Download the binary
wget https://storage.googleapis.com/kubernetes-release/release/v1.15.0/bin/linux/amd64/kubectl


#--- Move the binary to /usr/local/bin.
sudo mv kubectl /usr/bin


#--- Add the execution permission to the binary.
sudo chmod +x /usr/bin/kubectl


#--- Verify the installation.
sudo kubectl version