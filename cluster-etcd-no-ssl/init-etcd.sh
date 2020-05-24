sudo yum install etcd -y
sudo systemctl enable etcd
sudo systemctl stop etcd

cp /etc/etcd/etcd.conf /etc/etcd/etcd.conf_backup

INT_NAME="etcd1"
ETCD_HOST_IP=$(ip addr show $INT_NAME | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)

sudo cp /vagrant/etcd1.service /usr/lib/systemd/system/etcd.service 

tee /usr/lib/systemd/system/etcd.service << EOF

[Unit]
Description=Etcd Server
After=network.target
After=network-online.target
Wants=network-online.target

[Service]
Type=notify
WorkingDirectory=/var/lib/etcd/
EnvironmentFile=-/etc/etcd/etcd.conf
User=etcd
ExecStart=/usr/bin/etcd \
--name etcd-1 \
--data-dir /var/lib/etcd/default.etcd \
--initial-advertise-peer-urls http://192.168.205.51:2380 \
--listen-peer-urls http://192.168.205.51:2380 \
--listen-client-urls http://192.168.205.51:2379,http://127.0.0.1:2379,http://192.168.205.51:4001 \
--advertise-client-urls http://192.168.205.51:2379,http://192.168.205.51:4001 \
--initial-cluster-token etcd-cluster-1 \
--initial-cluster etcd-3=http://master3.etc.kube.io:2380,etcd-2=http://master2.etc.kube.io:2380,etcd-1=http://master1.etc.kube.io:2380 \
--initial-cluster-state new \
--heartbeat-interval 1000 \
--election-timeout 5000
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target

EOF


sudo systemctl daemon-reload

sudo mkdir /var/lib/etcd

sudo chown etcd:etcd /va/lib/etcd

#-- For CentOS / RHEL Linux distributions, set SELinux mode to permissive.
#sudo setenforce 0
#sudo sed -i 's/^SELINUX=.*/SELINUX=permissive/g' /etc/selinux/config

#-- If you have active firewall service, allow ports 2379 and 2380.
#sudo firewall-cmd --add-port={2379,2380}/tcp --permanent
#sudo firewall-cmd --reload

sudo systemctl start etcd

sudo systemctl status etcd

#---