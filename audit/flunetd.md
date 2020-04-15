
helm install fuentd stable/fluentd  --namespace kube-system \
--set image.repository=gcr.io/google-containers/fluentd-elasticsearch \
--set image.tag=v2.4.0


kubectl --namespace=kube-system get all -l "app=fluentd,release=fuentd"


helm upgrade fuentd stable/fluentd  --namespace kube-system --values values-fluentd-v1.yaml

host_entry="192.168.205.14 fluentd.dv.kube.io"
if [ $(cat /C/Windows/System32/drivers/etc/hosts | grep "$host_entry" | wc -l ) == 0  ] ; then
echo $host_entry >> /C/Windows/System32/drivers/etc/hosts 
fi;


