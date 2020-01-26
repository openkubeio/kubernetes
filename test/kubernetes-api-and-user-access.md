# Check all possible clusters, as your .KUBECONFIG may have multiple contexts:
kubectl config view -o jsonpath='{"Cluster name\tServer\n"}{range .clusters[*]}{.name}{"\t"}{.cluster.server}{"\n"}{end}'

# Select name of cluster you want to interact with from above output:
export CLUSTER_NAME="some_server_name"

# Point to the API server referring the cluster name
APISERVER=$(kubectl config view -o jsonpath="{.clusters[?(@.name==\"$CLUSTER_NAME\")].cluster.server}")

# Gets the token value
TOKEN=$(kubectl get secrets -o jsonpath="{.items[?(@.metadata.annotations['kubernetes\.io/service-account\.name']=='default')].data.token}"|base64 --decode)

# Explore the API with TOKEN
curl -X GET $APISERVER/api --header "Authorization: Bearer $TOKEN" --insecure

==========================================================================


APISERVER=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
TOKEN=$(kubectl get secret $(kubectl get serviceaccount default -o jsonpath='{.secrets[0].name}') -o jsonpath='{.data.token}' | base64 --decode )
curl -X GET $APISERVER/api --header "Authorization: Bearer $TOKEN" --insecure


===========================================================================


NAMESPACE=default

# Create a ServiceAccount named `jenkins-robot` in a given namespace.
$ kubectl -n <namespace> create serviceaccount jenkins-robot

# The next line gives `jenkins-robot` administator permissions for this namespace.
# * You can make it an admin over all namespaces by creating a `ClusterRoleBinding` instead of a `RoleBinding`.
# * You can also give it different permissions by binding it to a different `(Cluster)Role`.
$ kubectl -n $NAMESPACE create rolebinding jenkins-robot-binding --clusterrole=cluster-admin --serviceaccount=$NAMESPACE:jenkins-robot

# Get the name of the token that was automatically generated for the ServiceAccount `jenkins-robot`.
SECRET=$(kubectl -n $NAMESPACE get serviceaccount jenkins-robot -o go-template --template='{{range .secrets}}{{.name}}{{"\n"}}{{end}}')
jenkins-robot-token-d6d8z

# Retrieve the token and decode it using base64.
TOKEN=$(kubectl -n $NAMESPACE get secrets $SECRET -o go-template --template '{{index .data "token"}}' | base64 -d)
eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2V[...]



APISERVER=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
CLUSTER_NAME=icp
CLUSTER_CONTEXT=icp-context


kubectl config set-cluster icp --server=$APISERVER --insecure-skip-tls-verify=true
kubectl config set-context icp-context --cluster=icp
kubectl config set-credentials demo-user --token=$TOKEN
kubectl config set-credentials admin --token=ZXlKaGJHY2lPaUpTVXpJMU5pSXNJbXRwWkNJNkltcFJSSGhNUjBoNlNWTllPRzVDY21SR2RFbENjblV5ZDFOM1JVcE5OREYyWlhsNWVFTnRORUpHTTFVaWZRLmV5SnBjM01pT2lKcmRXSmxjbTVsZEdWekwzTmxjblpwWTJWaFkyTnZkVzUwSWl3aWEzVmlaWEp1WlhSbGN5NXBieTl6WlhKMmFXTmxZV05qYjNWdWRDOXVZVzFsYzNCaFkyVWlPaUprWldaaGRXeDBJaXdpYTNWaVpYSnVaWFJsY3k1cGJ5OXpaWEoyYVdObFlXTmpiM1Z1ZEM5elpXTnlaWFF1Ym1GdFpTSTZJbXBsYm10cGJuTXRjbTlpYjNRdGRHOXJaVzR0WTJSaU4zWWlMQ0pyZFdKbGNtNWxkR1Z6TG1sdkwzTmxjblpwWTJWaFkyTnZkVzUwTDNObGNuWnBZMlV0WVdOamIzVnVkQzV1WVcxbElqb2lhbVZ1YTJsdWN5MXliMkp2ZENJc0ltdDFZbVZ5Ym1WMFpYTXVhVzh2YzJWeWRtbGpaV0ZqWTI5MWJuUXZjMlZ5ZG1salpTMWhZMk52ZFc1MExuVnBaQ0k2SW1aaE56UTNZV0l4TFdJd01qY3ROREkyTUMxaU5XWm1MVEkxTmpkak9UVTBOalEzWWlJc0luTjFZaUk2SW5ONWMzUmxiVHB6WlhKMmFXTmxZV05qYjNWdWREcGtaV1poZFd4ME9tcGxibXRwYm5NdGNtOWliM1FpZlEuSU9aMnZ1ZWZxNTJLeVBaeUdtdWNOazQ1T1ljUmFBdm9VcHhXNUVYaXdmYVdzSUtiSWxxQWc2NGI4UWNMYzZaTmVSbUYxZjZxaUZrZ3VKMzJ5OFVneW9hRUxmeVV0cEdnbUo3SzBjcHdSSFdlUHZIdzEyUHBlSjVoSnJ2emlScjBrTVhpUV82ZzlwZnQ4bjhkZzlyUUtYQko0aHNFWXNHODNJNVdNOHpXcGZvdm1PMWk5aWdCQ0VVa2xoLU5MQzlzcFR3bXhiR2U3VDQyd0xJQTdSVVZYSFRSWG1sOHoyb2JxdkcwMHVod0FwY1VnNkppN3V0aFpDVDhJR3ZPSGpySi1LRUtJN18yWmlvdi1nbjJCUXBpdVVHVFVzbUwxZ3dQSGNwTEVUNGJ4UkJOVF92dmxJQXduSFNWUEtxa0Q0R2JQcUhsa2tGVGpHZzdtQW1lcXpGcS1B
kubectl config set-context icp-context --user=demo-user 
kubectl config use-context icpcma-context

kubectl get nodes
kubectl get pods

=================================================================================