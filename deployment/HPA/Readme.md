# Create deployment
VERSION=1.0 \
envsubst < ../Rolling-Update/deployment.yaml | kubectl apply -f -


kubectl apply -f hpa.yaml

===================================================
The HorizontalPodAutoscaler normally fetches metrics from a series of aggregated APIs (metrics.k8s.io, custom.metrics.k8s.io, and external.metrics.k8s.io). The metrics.k8s.io API is usually provided by metrics-server, which needs to be launched separately. See metrics-server for instructions. The HorizontalPodAutoscaler can also fetch metrics directly from Heapster.
====================================================

https://github.com/kubernetes-sigs/metrics-server

curl -LO https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.3.6/components.yaml -o metrics.yaml

kubectl apply -f metrics.yaml

kubectl delete -f metrics.yaml


helm install heapster stable/heapster  --namespace kube-system --set "rbac.create=true,command[0]=/heapster,command[1]=--source=kubernetes.summary_api:https://kubernetes.default.svc?kubeletHttps=true&kubeletPort=10250&useServiceAccount=true&insecure=true" 

helm delete heapster -n kube-system