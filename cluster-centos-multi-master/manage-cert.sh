#-- https://medium.com/@rob.blackbourn/how-to-use-cfssl-to-create-self-signed-certificates-d55f76ba5781

curl -L -O https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
curl -L -O https://pkg.cfssl.org/R1.2/cfssl_linux-amd64

sudo chmod +x cfssl*

sudo mv cfssl_linux-amd64 /usr/bin/cfssl
sudo mv cfssljson_linux-amd64 /usr/bin/cfssljson

sudo mkdir cfssl


#-- The Certificate Authority - create a self signed certificate authority

sudo tee ca.json << EOF
{
  "CN": "My Kube Root CA",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
  {
    "C": "GB",
    "L": "London",
    "O": "Custom Widgets",
    "OU": "Custom Widgets Root CA",
    "ST": "England"
  }
 ]
}
EOF

#-- Create “ca.pem” and “ca-key.pem” along with ca.csr
sudo cfssl gencert -initca ca.json | cfssljson -bare ca

#-- The Profiles - describes general details about the certificate.

sudo tee cfssl.json << EOF
{
  "signing": {
    "default": {
      "expiry": "8760h"
    },
    "profiles": {
      "intermediate_ca": {
        "usages": [
            "signing",
            "digital signature",
            "key encipherment",
            "cert sign",
            "crl sign",
            "server auth",
            "client auth"
        ],
        "expiry": "8760h",
        "ca_constraint": {
            "is_ca": true,
            "max_path_len": 0, 
            "max_path_len_zero": true
        }
      },
      "peer": {
        "usages": [
            "signing",
            "digital signature",
            "key encipherment", 
            "client auth",
            "server auth"
        ],
        "expiry": "8760h"
      },
      "server": {
        "usages": [
          "signing",
          "digital signing",
          "key encipherment",
          "server auth"
        ],
        "expiry": "8760h"
      },
      "client": {
        "usages": [
          "signing",
          "digital signature",
          "key encipherment", 
          "client auth"
        ],
        "expiry": "8760h"
      }
    }
  }
}
EOF

#-- The Intermediate CA - create an intermediate certificate authority 

sudo tee intermediate-ca.json << EOF
{
  "CN": "Custom Widgets Intermediate CA",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C":  "GB",
      "L":  "London",
      "O":  "Custom Widgets",
      "OU": "Custom Widgets Intermediate CA",
      "ST": "England"
    }
  ],
  "ca": {
    "expiry": "42720h"
  }
}
EOF

#-- commands creates “intermediate_ca.pem”, “intermediate_ca.csr” and “intermediate_ca-key.pem” 
#-- the second “sign” command uses the CA produced previously to sign the intermediate CA
#-- It also uses the “cfssl.json” profile and specifies the “intermediate_ca” profile

sudo cfssl gencert -initca intermediate-ca.json | cfssljson -bare intermediate_ca
sudo cfssl sign -ca ca.pem -ca-key ca-key.pem -config cfssl.json -profile intermediate_ca intermediate_ca.csr | cfssljson -bare intermediate_ca

#-- Host Certificates - host certificate config file “host1.json”

SR=master1
CN=$SR.etc.kube.io
IP=192.168.205.51

sudo tee $SR.json << EOF
{
  "CN": "$CN",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
  {
    "C": "GB",
    "L": "London",
    "O": "Custom Widgets",
    "OU": "Custom Widgets Hosts",
    "ST": "England"
  }
  ],
  "hosts": [
    "$CN",
    "$IP",
    "127.0.0.1"	
  ]
}
EOF

#-- To generate the certificates with the above config do the following:

cfssl gencert -ca intermediate_ca.pem -ca-key intermediate_ca-key.pem -config cfssl.json -profile=peer  master1.json | cfssljson -bare master1-peer

cfssl gencert -ca intermediate_ca.pem -ca-key intermediate_ca-key.pem -config cfssl.json -profile=peer  master2.json | cfssljson -bare master2-peer

cfssl gencert -ca intermediate_ca.pem -ca-key intermediate_ca-key.pem -config cfssl.json -profile=peer  master3.json | cfssljson -bare master3-peer


