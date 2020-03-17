## Helm install
## helm install --name-template my-release --set mysqlRootPassword=secretpassword,mysqlUser=my-user,mysqlPassword=my-password,mysqlDatabase=my-database,persistence.storageClass=haketi stable/mysql

[[ ! $(kubectl get ns |grep mysql |awk '{ if ( $1 == "mysql" ) print $1}' | wc -l) == 1 ]] && kubectl create ns mysql

mysqlpassword=$(echo -n 'mysqlpassword' | base64)
mysqlrootpassword=$(echo -n 'mysqlrootpassword' | base64)

cat << EOF > mysql.secret.yaml
apiVersion: v1
data:
  mysql-password: $mysqlpassword
  mysql-root-password: $mysqlrootpassword
kind: Secret
metadata:
  labels:
    app: mysql-v1
    chart: mysql-v1
  name: mysql
  namespace: mysql
type: Opaque
EOF

kubectl apply -f mysql.pvc.yaml
kubectl apply -f mysql.secret.yaml
kubectl apply -f mysql.deployment.yaml
kubectl apply -f mysql.service.yaml



# MYSQL_ROOT_PASSWORD=$(kubectl get secret --namespace mysql mysql -o jsonpath="{.data.mysql-root-password}" | base64 --decode; echo)

# kubectl run -i --tty ubuntu --image=ubuntu:16.04 --restart=Never -- bash 
# > apt-get update && apt-get install mysql-client -y
# > mysql -h mymysql.mysql.svc.cluster.local -P 3306 -u root -p${MYSQL_ROOT_PASSWORD}
# >

