#--- Create cert directory

mkdir -p /data/ha/certs/ && cd /data/ha/certs/


#--- Create the certificate authority configuration file.

sudo tee /data/ha/certs/ca-config.json << EOF
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


#--- Create the certificate authority signing request configuration file.

sudo tee /data/ha/certs/ca-csr.json << EOF
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


#--- Generate the certificate authority certificate and private key.

cfssl gencert -initca /data/ha/certs/ca-csr.json | cfssljson -bare ca


#--- Verify that the ca-key.pem and the ca.pem were generated.

ls -latr /data/ha/certs/