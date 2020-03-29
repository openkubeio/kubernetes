git clone https://github.com/oracle/mysql-operator.git

cd mysql-operator

kubectl create ns mysql-operator

helm install mysql-operator mysql-operator --namespace=mysql-operator

helm delete mysql-operator

Create a simple MySQL cluster

kubectl create ns my-namespace

cat <<EOF | kubectl create -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: mysql-agent
  namespace: my-namespace
---
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: mysql-agent
  namespace: my-namespace
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: mysql-agent
subjects:
- kind: ServiceAccount
  name: mysql-agent
  namespace: my-namespace
EOF

cat <<EOF | kubectl apply -f -
apiVersion: mysql.oracle.com/v1alpha1
kind: Cluster
metadata:
  name: my-app-db
  namespace: my-namespace
spec:
  members: 1
  rootPasswordSecret:
    name: mysql-root-user-secret  
EOF


kubectl -n my-namespace get mysqlclusters
kubectl -n my-namespace delete mysqlclusters my-app-db

cat <<EOF | kubectl apply -f -
apiVersion: mysql.oracle.com/v1alpha1
kind: Cluster
metadata:
  name: mysql-cluster-with-volume
spec:
  members: 1
  rootPasswordSecret:
    name: mysql-root-user-secret 
  volumeClaimTemplate:
    metadata:
      name: data
    spec:
      storageClassName: nfs-pvc-test
      accessModes:
        - ReadWriteMany
      resources:
        requests:
          storage: 1Gi
EOF


