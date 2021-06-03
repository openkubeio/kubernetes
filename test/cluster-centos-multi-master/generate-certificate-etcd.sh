#--- Go to the cert dir
cd /data/ha/certs/

#--- Create the certificate signing request configuration file.

sudo tee /data/ha/certs/kubernetes-csr.json <<EOF
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

#--- Generate the certificate and private key.

cfssl gencert \
-ca=/data/ha/certs/ca.pem \
-ca-key=/data/ha/certs/ca-key.pem \
-config=/data/ha/certs/ca-config.json \
-hostname=192.168.205.90,192.168.205.91,192.168.205.92,192.168.205.93,127.0.0.1,kubernetes.default \
-profile=kubernetes /data/ha/certs/kubernetes-csr.json | cfssljson -bare kubernetes


#--- Verify that the kubernetes-key.pem and the kubernetes.pem file were generated.

ls -latr
