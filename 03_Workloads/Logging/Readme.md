Official elasticsearch helm release 
> https://github.com/elastic/helm-charts/tree/7.8/elasticsearch


------------------------------------------------

#### setup elastic with no security enabled

helm install es-master   --version 7.8.1 elastic/elasticsearch --values es-7.8.1-values-master.yaml

helm install es-data     --version 7.8.1 elastic/elasticsearch --values es-7.8.1-values-data.yaml

helm install es-client   --version 7.8.1 elastic/elasticsearch --values es-7.8.1-values-client.yaml

kubectl exec alpine -- curl -sL http://elasticsearch-master:9200/_cluster/state?pretty  

kubectl exec alpine -- curl -sL http://elasticsearch-client:9200/_cluster/state?pretty  

kubectl exec alpine -- curl -sL http://elasticsearch-client:9200/_cat/nodes?v

helm install es-kibana   --version 7.8.1 elastic/kibana   --values es-7.8.1-values-kibana.yaml

helm install es-filebeat --version 7.8.1 elastic/filebeat --values es-7.8.1-values-filebeat.yaml


---------------------------------------------

#### setup elastic with security enabled

helm install es-master   --version 7.8.1 elastic/elasticsearch --values es-7.8.1-values-secure-master.yaml

kubectl exec alpine -- curl -sL -u elastic:elasticelastic   http://elasticsearch-master:9200/_cluster/state?pretty   

helm install es-data   --version 7.8.1 elastic/elasticsearch --values es-7.8.1-values-secure-data.yaml

helm install es-client   --version 7.8.1 elastic/elasticsearch --values es-7.8.1-values-secure-client.yaml

kubectl exec alpine -- curl -sL -u elastic:elasticelastic http://elasticsearch-client:9200/_cluster/state?pretty  

kubectl exec alpine -- curl -sL -u elastic:elasticelastic  http://elasticsearch-client:9200/_cat/nodes?v


helm install es-kibana   --version 7.8.1 elastic/kibana   --values es-7.8.1-values-secure-kibana.yaml


---------------------------------------------------------------
#### setup elastic with  security and ssl transport enabled

kubectl create secret generic elastic-certificates --from-file=elastic-certificates.p12 

helm install es-master   --version 7.8.1 elastic/elasticsearch --values elasticsearch.7.8.1.master.values.yaml

helm install es-data     --version 7.8.1 elastic/elasticsearch --values elasticsearch.7.8.1.data.values.yaml

helm install es-client   --version 7.8.1 elastic/elasticsearch --values elasticsearch.7.8.1.client.values.yaml

helm install es-kibana   --version 7.8.1 elastic/kibana        --values elasticsearch.7.8.1.kibana.values.yaml

helm install es-filebeat --version 7.8.1 elastic/filebeat      --values elasticsearch.7.8.1.filebeat.values.yaml

-------------------------------------------------------------

https://www.elastic.co/guide/en/elasticsearch/reference/current/users-command.html
https://medium.com/@thulasya/deploy-elasticsearch-on-kubernetes-via-helm-in-google-kubernetes-cluster-da722f3a8883
https://sematext.com/blog/kubernetes-elasticsearch/
https://docs.portworx.com/portworx-install-with-kubernetes/application-install-with-kubernetes/elastic-search-and-kibana/
https://github.com/thisisabhishek/efk-with-xpack-security
https://www.elastic.co/guide/en/elasticsearch/reference/7.x/modules-discovery-hosts-providers.html
https://www.studytonight.com/post/setup-elasticsearch-with-authentication-xpack-security-enabled-on-kubernetes#
https://www.studytonight.com/post/setup-kibana-with-elastic-cluster-authentication-xpack-security-enabled
https://www.studytonight.com/post/setup-fluent-bit-with-elasticsearch-authentication-enabled-in-kubernetes
https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-node.html




