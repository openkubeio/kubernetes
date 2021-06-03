echo "--- Executing script init_proxy"

echo "--- Disable selinux "
sudo setenforce 0
sudo sed -i 's/^SELINUX=/#&/' /etc/selinux/config  
sudo echo "SELINUX=disabled" >> /etc/selinux/config 


echo "--- Update apt and install haproxy"
sudo yum install -y haproxy
sudo systemctl enable haproxy

echo "--- Update haproxy config"
sudo tee -a /etc/haproxy/haproxy.cfg << EOF
#### Config of Ingress Traffic to Kubernetes

frontend localhost
	bind *:443
    option tcplog
    mode tcp
    default_backend nodes
backend nodes
   mode tcp
   balance roundrobin
   option ssl-hello-chk
   server node01 192.168.205.52:30001 check
   server node02 192.168.205.53:30001 check

####END of Config
EOF

echo "--- Check haproxy config status"
haproxy -f /etc/haproxy/haproxy.cfg -c -V

echo "--- Restarting haproxy service"
sudo systemctl stop haproxy
sleep 5
sudo systemctl start haproxy