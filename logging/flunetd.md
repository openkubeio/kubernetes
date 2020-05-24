
kubectl create ns  kube-logging

kubectl create configmap fluentd-config  --from-file fluent-test.conf -n kube-logging

kubectl delete configmap fluentd-config  -n kube-logging

kubectl apply -f fluentd-demo.yaml

-----------------------------------------------------------------------
docker network create my-network

docker run --name my-elastic --rm -d -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:7.6.2
docker network connect my-network my-elastic

docker run --name my-kibana  --rm -d -p 5601:5601 -e "ELASTICSEARCH_HOSTS=http://my-elastic:9200" docker.elastic.co/kibana/kibana:7.6.2
docker network connect my-network my-kibana

https://github.com/uken/fluent-plugin-elasticsearch/blob/master/README.md


http://ip172-18-0-29-bqn52kdim9m000915uo0-9200.direct.labs.play-with-docker.com/_cat/indices/

http://ip172-18-0-29-bqn52kdim9m000915uo0-9200.direct.labs.play-with-docker.com/_cat/indices/twi*?v&s=index

http://ip172-18-0-81-bqnc7ciosm4g00flh9hg-9200.direct.labs.play-with-docker.com/logstash-2020.05.03?pretty

http://ip172-18-0-81-bqnc7ciosm4g00flh9hg-9200.direct.labs.play-with-docker.com/logstash-2020.05.03/_search

http://localhost:9200/company/employee/_search


https://medium.com/@ashish_fagna/getting-started-with-elasticsearch-creating-indices-inserting-values-and-retrieving-data-e3122e9b12c6
-----------------------------------------------------------------------

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


