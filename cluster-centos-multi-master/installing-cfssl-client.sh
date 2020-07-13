
#---Download the binaries.
wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
wget https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64


#--- Move the binaries to /usr/local/bin.
sudo mv cfssl_linux-amd64 /usr/bin/cfssl
sudo mv cfssljson_linux-amd64 /usr/bin/cfssljson


#--- Add the execution permission to the binaries.
sudo chmod +x /usr/bin/cfssl*


#--- Verify the installation.
sudo cfssl version

