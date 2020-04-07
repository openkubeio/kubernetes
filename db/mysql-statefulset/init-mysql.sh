# Cretae namespace if not exists
[[ ! $(kubectl get ns |grep mysql-stateful |awk '{ if ( $1 == "mysql-stateful" ) print $1}' | wc -l) == 1 ]] && kubectl create ns mysql-stateful

kubectl delete configmap mysql-config -n mysql-stateful
kubectl create configmap mysql-config --from-file my.cnf -n mysql-stateful

mysqlpassword=$(echo -n 'mysqlpassword' | base64)
mysqlrootpassword=$(echo -n 'mysqlrootpassword' | base64)

cat << EOF > mysql-secret.yaml
apiVersion: v1
data:
  mysql-password: $mysqlpassword
  mysql-root-password: $mysqlrootpassword
kind: Secret
metadata:
  labels:
    app: mysql
    chart: mysql
  name: mysql
  namespace: mysql-stateful
type: Opaque
EOF

kubectl apply -f mysql-sa.yaml
kubectl apply -f mysql-secret.yaml
kubectl apply -f mysql-statefulset.yaml
kubectl apply -f mysql-service.yaml
