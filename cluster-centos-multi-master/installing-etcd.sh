
#--- Create a configuration directory for Etcd.
sudo mkdir /etc/etcd /var/lib/etcd


#--- Move the certificates to the configuration directory.
sudo cp /data/ha/certs/ca.pem /data/ha/certs/kubernetes.pem /data/ha/certs/kubernetes-key.pem /etc/etcd


#--- Download the etcd binaries
sudo wget https://github.com/etcd-io/etcd/releases/download/v3.3.13/etcd-v3.3.13-linux-amd64.tar.gz -P /root/


#--- Extract the etcd archive.
sudo tar -C /root -xvzf   /root/etcd-v3.3.13-linux-amd64.tar.gz


#--- Move the etcd binaries to /usr/bin
sudo mv /root/etcd-v3.3.13-linux-amd64/etcd* /usr/bin/  

#--- export IP address
IPADDR_ENP0S8=$(ifconfig eth1 | grep inet | grep broadcast | awk '{print $2}')

#--- Create an etcd systemd unit file.

sudo tee /etc/systemd/system/etcd.service <<EOF

[Unit]
Description=etcd
Documentation=https://github.com/coreos

[Service]
ExecStart=/usr/bin/etcd \
  --name ${IPADDR_ENP0S8} \
  --cert-file=/etc/etcd/kubernetes.pem \
  --key-file=/etc/etcd/kubernetes-key.pem \
  --peer-cert-file=/etc/etcd/kubernetes.pem \
  --peer-key-file=/etc/etcd/kubernetes-key.pem \
  --trusted-ca-file=/etc/etcd/ca.pem \
  --peer-trusted-ca-file=/etc/etcd/ca.pem \
  --peer-client-cert-auth \
  --client-cert-auth \
  --initial-advertise-peer-urls https://${IPADDR_ENP0S8}:2380 \
  --listen-peer-urls https://${IPADDR_ENP0S8}:2380 \
  --listen-client-urls https://${IPADDR_ENP0S8}:2379,http://127.0.0.1:2379 \
  --advertise-client-urls https://${IPADDR_ENP0S8}:2379 \
  --initial-cluster-token etcd-cluster-0 \
  --initial-cluster 192.168.205.90=https://192.168.205.90:2380,192.168.205.91=https://192.168.205.91:2380,192.168.205.92=https://192.168.205.92:2380 \
  --initial-cluster-state new \
  --data-dir=/var/lib/etcd
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target

EOF


#--- Reload the daemon configuration.
sudo systemctl daemon-reload


#--- Enable etcd to start at boot time.
sudo systemctl enable etcd


#--- Start etcd.
sudo systemctl start etcd


#--- Verify that the cluster is up and running.
ETCDCTL_API=3 etcdctl member list


#--- Check transaction
ETCDCTL_API=3 etcdctl get /message --insecure-skip-tls-verify=true
/message
Hello World

