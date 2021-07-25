## Create a dedicated namespace for API Access

> **Create namespace for monitoring**
``` 
kubectl create ns dynatrace
```
> **Create service account, ClusterRole and ClusterRoleBinding**
```
kubectl apply -f https://github.com/openkubeio/kubernetes/blob/master/01_Cluster_Administration/Api_Access/kubernetes-monitoring-service-account.yaml
```



## Access Kubernetes  APIs from outside the cluster

> **Export access variables**
```
APISERVER=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')

TOKEN=$(kubectl get secret $(kubectl get sa dynatrace-monitoring -o jsonpath='{.secrets[0].name}' -n dynatrace) -o jsonpath='{.data.token}' -n dynatrace | base64 --decode)

kubectl get secret $(kubectl get sa dynatrace-monitoring -o jsonpath='{.secrets[0].name}' -n dynatrace) -o jsonpath='{.data.ca\.crt}' -n dynatrace | base64 --decode > ca.crt
```
> **Explore API with TOKEN**
```
curl -sL --cacert ca.crt --header "Authorization: Bearer ${TOKEN}" -X GET ${APISERVER}/api

curl -sL --cacert ca.crt --header "Authorization: Bearer ${TOKEN}" -X GET ${APISERVER}/api/v1/namespaces/test/pods

curl -sL --cacert ca.crt --header "Authorization: Bearer ${TOKEN}" -X GET ${APISERVER}/api/v1/namespaces/dynatrace/pods
```



## Access Kubernetes  APIs from within a pod in cluster

> **Create a pod running with service account**
```
kubectl run alpine --image=openkubeio/alpine --restart=Never --serviceaccount=dynatrace-monitoring --namespace=dynatrace 

kubectl exec -it -n dynatrace alpine -- sh 
```
> **Export access variables**
```
# Point to the internal API server hostname
APISERVER=https://kubernetes.default.svc

# Path to ServiceAccount token
SERVICEACCOUNT=/var/run/secrets/kubernetes.io/serviceaccount

# Read this Pod's namespace
NAMESPACE=$(cat ${SERVICEACCOUNT}/namespace)

# Read the ServiceAccount bearer token
TOKEN=$(cat ${SERVICEACCOUNT}/token)

# Reference the internal certificate authority (CA)
CACERT=${SERVICEACCOUNT}/ca.crt
```
> **Explore API with TOKEN**
```
curl -sL --cacert ${CACERT} --header "Authorization: Bearer ${TOKEN}" -X GET ${APISERVER}/api

curl -sL --cacert ${CACERT} --header "Authorization: Bearer ${TOKEN}" -X GET ${APISERVER}/api/v1/namespaces/dynatrace/pods
```
 
