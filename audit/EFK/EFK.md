kubectl create ns  kube-logging

kubectl apply -f elasticsearch.yaml

kubectl apply -f kibana.yaml

kubectl apply -f fluentd.yaml

