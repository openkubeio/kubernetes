
#--- Installing cfssl Cloud Flare SSL tool to generate the different certificates

#--- Installing cfssl
#--- -- Download the binaries.

sudo wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
sudo wget https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64

#-- -- Add the execution permission to the binaries.

sudo chmod +x cfssl*

#--- -- Move the binaries to /usr/bin
sudo mv cfssl_linux-amd64 /usr/bin/cfssl
sudo mv cfssljson_linux-amd64 /usr/bin/cfssljson

#--- -- Verify the installation.

cfssl version




#--- Generating the TLS certificates

#--- -- Create the CA certificate authority configuration file.

tee ca-config.json << EOF
{
  "signing": {
    "default": {
      "expiry": "8760h"
    },
    "profiles": {
      "kubernetes": {
        "usages": ["signing", "key encipherment", "server auth", "client auth"],
        "expiry": "8760h"
      }
    }
  }
}
EOF

#--- -- Create the CA SR certificate authority signing request configuration file.

tee ca-csr.json << EOF
{
  "CN": "Kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
  {
    "C": "IE",
    "L": "Cork",
    "O": "Kubernetes",
    "OU": "CA",
    "ST": "Cork Co."
  }
 ]
}
EOF

#--- -- Generate the certificate authority certificate and private key.

cfssl gencert -initca ca-csr.json | cfssljson -bare ca

#--- -- Verify that the ca-key.pem and the ca.pem were generated.

ls -la


#--- Creating the certificate for the Etcd cluster

#--- -- Create the CSR certificate signing request configuration file.

tee kubernetes-csr.json << EOF
{
  "CN": "kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
  {
    "C": "IE",
    "L": "Cork",
    "O": "Kubernetes",
    "OU": "Kubernetes",
    "ST": "Cork Co."
  }
 ]
}
EOF

#--- -- Generate the certificate and private key.

cfssl gencert \
-ca=ca.pem \
-ca-key=ca-key.pem \
-config=ca-config.json \
-hostname=10.10.10.90,10.10.10.91,10.10.10.92,10.10.10.93,127.0.0.1,kubernetes.default \
-profile=kubernetes kubernetes-csr.json | \
cfssljson -bare kubernetes


#--- -- Verify that the kubernetes-key.pem and the kubernetes.pem file were generated.

ls -la

