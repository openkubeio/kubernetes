https://www.digitalocean.com/community/tutorials/how-to-set-up-an-elasticsearch-fluentd-and-kibana-efk-logging-stack-on-kubernetes


helm install fluentd stable/fluentd  --namespace kube-system

helm upgrade fluentd stable/fluentd  --namespace kube-system --values fluentd-values-1.yaml

kubectl --namespace=kube-system get all -l "app=fluentd,release=fluentd"

helm rollback fluentd --namespace kube-system

helm delete fluentd --namespace kube-system

-----------------------------------------------------------------------

helm install elasticsearch  stable/elasticsearch --namespace audit

helm get values elasticsearch  --all --output  yaml --namespace audit > elasticsearch-values-0.yaml

helm upgrade elasticsearch stable/elasticsearch  --namespace audit --values elasticsearch-values-1.yaml

kubectl --namespace=audit get all -l "app=elasticsearch,release=elasticsearch"

app=elasticsearch,component=client,release=elasticsearch

helm rollback elasticsearch --namespace audit

helm delete elasticsearch --namespace audit

-----------------------------------------------------------------------







host_entry="192.168.205.14 fluentd.dv.kube.io"
if [ $(cat /C/Windows/System32/drivers/etc/hosts | grep "$host_entry" | wc -l ) == 0  ] ; then
echo $host_entry >> /C/Windows/System32/drivers/etc/hosts 
fi;


