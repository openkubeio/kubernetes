kubectl create ns monitoring

kubectl create configmap grafana --from-file grafana.ini -n monitoring

adminuser=$(echo -n 'adminuser' | base64)
adminpassword=$(echo -n 'adminpassword' | base64)

cat << EOF > grafana-secret.yaml
apiVersion: v1
data:
  admin-password: $adminpassword
  admin-user: $adminuser
kind: Secret
metadata:
  labels:
    app.kubernetes.io/name: grafana
  name: grafana
  namespace: monitoring
type: Opaque
EOF

kubectl apply -f grafana-secret.yaml
kubectl apply -f grafana-deployment.yaml
kubectl apply -f grafana-service.yaml
kubectl apply -f grafana-ingress.yaml

host_entry="192.168.205.14 grafana.dv.kube.io"
if [ $(cat /C/Windows/System32/drivers/etc/hosts | grep "$host_entry" | wc -l ) == 0  ] ; then
echo $host_entry >> /C/Windows/System32/drivers/etc/hosts 
fi;

