-----
apiVersion: v1
data:
  admin-password: NEtwNTc3b0lObGN2bG03emlWaE8xWU5wSlNzUDNBaXJaWU54bGxnUg==
  admin-user: YWRtaW4=
kind: Secret
metadata:
  labels:
    app.kubernetes.io/name: grafana
  name: grafana
  namespace: management
  resourceVersion: "186008"
type: Opaque



kubectl create ns management 

helm install grafana stable/grafana  --namespace management

helm install node-exporter stable/prometheus-node-exporter --namespace management

helm install prometheus stable/prometheus --values values.prometheus.yaml --namespace management


helm install prometheus stable/prometheus-operator --namespace management --values Values.yaml

helm upgrade prometheus stable/prometheus-operator --namespace management --values Values.yaml

helm delete prometheus --namespace management 

helm delete grafana --namespace management 

----

kubectl -n management get pods 


$ kubectl get secret --namespace management prometheus-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ;
 echo
 
 

host_entry="192.168.205.14 prometheus.dv.kube.io"
if [ $(cat /C/Windows/System32/drivers/etc/hosts | grep "$host_entry" | wc -l ) == 0  ] ; then
echo $host_entry >> /C/Windows/System32/drivers/etc/hosts 
fi;


helm install prometheus  stable/prometheus-operator --namespace=monitoring

kubectl --namespace monitoring get pods -l "release=prometheus"

helm delete prometheus -n monitoring