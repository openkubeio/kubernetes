
#--- Installing and configuring Etcd

#--- -- Create a configuration directory for Etcd.

sudo mkdir /etc/etcd /var/lib/

#--- -- Move the certificates to the configuration directory.

sudo mv certs/ca.pem certs/kubernetes.pem certs/kubernetes-key.pem /etc/etcd

#--- -- Download the etcd binaries.

wget https://github.com/etcd-io/etcd/releases/download/v3.3.13/etcd-v3.3.13-linux-amd64.tar.gz

#--- -- Extract the etcd archive.

$ tar xvzf etcd-v3.3.13-linux-amd64.tar.gz

#--- -- Move the etcd binaries to /usr/bin

$ sudo mv etcd-v3.3.13-linux-amd64/etcd* /usr/bin/

#--- -- Create an etcd systemd unit file

tee /etc/systemd/system/etcd.service << EOF

[Unit]
Description=etcd
Documentation=https://github.com/coreos

[Service]
ExecStart=/usr/bin/etcd \
  --name 10.10.10.90 \
  --cert-file=/etc/etcd/kubernetes.pem \
  --key-file=/etc/etcd/kubernetes-key.pem \
  --peer-cert-file=/etc/etcd/kubernetes.pem \
  --peer-key-file=/etc/etcd/kubernetes-key.pem \
  --trusted-ca-file=/etc/etcd/ca.pem \
  --peer-trusted-ca-file=/etc/etcd/ca.pem \
  --peer-client-cert-auth \
  --client-cert-auth \
  --initial-advertise-peer-urls https://10.10.10.90:2380 \
  --listen-peer-urls https://10.10.40.10:2380 \
  --listen-client-urls https://10.10.10.90:2379,http://127.0.0.1:2379 \
  --advertise-client-urls https://10.10.10.90:2379 \
  --initial-cluster-token etcd-cluster-0 \
  --initial-cluster 10.10.10.90=https://10.10.10.90:2380,10.10.10.91=https://10.10.10.91:2380,10.10.10.92=https://10.10.10.92:2380 \
  --initial-cluster-state new \
  --data-dir=/var/lib/etcd
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

#--- -- Reload the daemon configuration.

sudo systemctl daemon-reload

#--- -- Enable etcd to start at boot time.

sudo systemctl enable etcd

#--- -- Start etcd.
sudo systemctl start etcd

