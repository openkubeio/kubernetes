Check all possible clusters in KUBECONFIG

	$ kubectl config view -o jsonpath='{"Cluster name\tServer\n"}{range .clusters[*]}{.name}{"\t"}{.cluster.server}{"\n"}{end}'

Select name of cluster you want to interact with from above output:

	$ export CLUSTER_NAME="some_server_name"

Point to the API server referring the cluster name

	$ APISERVER=$(kubectl config view -o jsonpath="{.clusters[?(@.name==\"$CLUSTER_NAME\")].cluster.server}")

Gets the token value

	$ TOKEN=$(kubectl get secrets -o jsonpath="{.items[?(@.metadata.annotations['kubernetes\.io/service-account\.name']=='default')].data.token}"|base64 --decode)

Explore the API with TOKEN

	$ curl -X GET $APISERVER/api --header "Authorization: Bearer $TOKEN" --insecure



Quick test with your conig file

	$ APISERVER=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
	$ TOKEN=$(kubectl get secret $(kubectl get serviceaccount default -o jsonpath='{.secrets[0].name}') -o jsonpath='{.data.token}' | base64 --decode )
	$ curl -X GET $APISERVER/api --header "Authorization: Bearer $TOKEN" --insecure



===================================================
Creating a user namespace and access via user token

	$ NAMESPACE=default

Create a ServiceAccount named `jenkins-robot` in a given namespace.

	$ kubectl -n <namespace> create serviceaccount jenkins-robot

The next line gives `jenkins-robot` administator permissions for this namespace.
You can make it an admin over all namespaces by creating a `ClusterRoleBinding` instead of a `RoleBinding`.
You can also give it different permissions by binding it to a different `(Cluster)Role`.

	$ kubectl -n $NAMESPACE create rolebinding jenkins-robot-binding --clusterrole=cluster-admin --serviceaccount=$NAMESPACE:jenkins-robot

Get the name of the token that was automatically generated for the ServiceAccount `jenkins-robot`.

	$ SECRET=$(kubectl -n $NAMESPACE get serviceaccount jenkins-robot -o go-template --template='{{range .secrets}}{{.name}}{{"\n"}}{{end}}')


Retrieve the token and decode it using base64

	$ TOKEN=$(kubectl -n $NAMESPACE get secrets $SECRET -o go-template --template '{{index .data "token"}}' | base64 -d)

	$ APISERVER=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')

	$ CLUSTER_NAME=icp

	$ CLUSTER_CONTEXT=icp-context


	$ kubectl config set-cluster icp --server=$APISERVER --insecure-skip-tls-verify=true
	$ kubectl config set-context icp-context --cluster=icp
	$ kubectl config set-credentials demo-user --token=$TOKEN
	$ kubectl config set-context icp-context --user=demo-user 
	$ kubectl config use-context icpcma-context
	
	$ kubectl get nodes
	$ kubectl get pods
