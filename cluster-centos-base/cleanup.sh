#sudo package-cleanup -y --oldkernels --count=1
#sudo yum -y autoremove
#sudo yum clean all
sudo rm -rf /tmp/*
sudo rm -f /var/log/wtmp /var/log/btmp
sudo dd if=/dev/zero of=/EMPTY bs=1M count=1024
sudo rm -f /EMPTY
sudo cat /dev/null > ~/.bash_history && history -c