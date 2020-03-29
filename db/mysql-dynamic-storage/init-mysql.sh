# Cretae namespace if not exists
[[ ! $(kubectl get ns |grep mysql |awk '{ if ( $1 == "mysql" ) print $1}' | wc -l) == 1 ]] && kubectl create ns mysql

# Must ensure ns client is installed on worker node
vagrant ssh worker1.dv.kube.io -- -t "sudo apt install nfs-common -y "
vagrant ssh worker2.dv.kube.io -- -t "sudo apt install nfs-common -y "


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
    app: mysql-v1
    chart: mysql-v1
  name: mysql
  namespace: mysql
type: Opaque
EOF

kubectl apply -f mysql-pvc.yaml
kubectl apply -f mysql-secret.yaml
kubectl apply -f mysql-deployment.yaml
kubectl apply -f mysql-service.yaml

# To resuse the pv post pvc recreate, remove pvc uid and id rom pvc-claim-ref