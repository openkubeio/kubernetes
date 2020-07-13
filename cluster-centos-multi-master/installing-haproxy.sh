echo "--- Executing script init_proxy"

echo "--- Disable selinux "
sudo setenforce 0
sudo sed -i 's/^SELINUX=/#&/' /etc/selinux/config  
sudo echo "SELINUX=disabled" | sudo tee -a /etc/selinux/config 


echo "--- Update apt and install haproxy"
sudo yum install -y haproxy
sudo systemctl enable haproxy

echo "--- Update haproxy config"
sudo tee -a /etc/haproxy/haproxy.cfg << EOF

#### Configure  traffic for Kubernet master

frontend kubernetes
    bind *:6443
    option tcplog
    mode tcp
    default_backend kubernetes-master-nodes
backend kubernetes-master-nodes
   mode tcp
   balance roundrobin
   option ssl-hello-chk
   server node1 192.168.205.90:6443 check
   server node2 192.168.205.91:6443 check
   server node2 192.168.205.92:6443 check

####END of Config
EOF

echo "--- Check haproxy config status"
haproxy -f /etc/haproxy/haproxy.cfg -c -V

echo "--- Restarting haproxy service"
sudo systemctl stop haproxy
sleep 5
sudo systemctl start haproxy