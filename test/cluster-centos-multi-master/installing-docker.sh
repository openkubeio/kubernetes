echo "--- install-docker.sh in execution" 

echo "---update yum packages"
sudo yum install -y yum-utils device-mapper-persistent-data lvm2 ca-certificates

echo "--- Add Docker’s official GPG key"
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

echo "--- List stable repository for docker"
sudo yum list docker-ce.x86_64 --showduplicates | sort -r | grep 19.

echo "--- Installing docker"
sudo yum install -y docker-ce-19.03.0

echo "--- enablr docker service"
sudo systemctl enable docker

echo "--- start docker service"
sudo systemctl start docker

echo "--- Checking docker status"
sudo docker version

echo "--- Update docker cgroup driver"
sudo tee  /etc/docker/daemon.json  << EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

echo "--- Restart docker"
sudo systemctl restart docker

echo "--- Verifying docker is working"
sudo docker images