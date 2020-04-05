# Cretae namespace if not exists
[[ ! $(kubectl get ns |grep monitor |awk '{ if ( $1 == "monitor" ) print $1}' | wc -l) == 1 ]] &&  kubectl create ns monitor
 
kubectl create configmap prometheus-server-conf --from-file prometheus.config -n monitor

kubectl apply -f rbac.yaml
kubectl apply -f prometheus-deployment.yaml
kubectl apply -f prometheus-service.yaml
kubectl apply -f prometheus-ingress.yaml


# For updating prometheus.config 
kubectl delete configmap prometheus-server-conf  -n monitor
kubectl delete deploy prometheus-deployment -n monitor


host_entry="192.168.205.14 prometheus.dv.kube.io"
if [ $(cat /C/Windows/System32/drivers/etc/hosts | grep "$host_entry" | wc -l ) == 0  ] ; then
echo $host_entry >> /C/Windows/System32/drivers/etc/hosts 
fi;



DEBUG
-----
kubectl -n monitor get pods 
kubectl -n monitor get pods --no-headers  -o custom-columns=":metadata.name" 

kubectl -n monitor describe pod $(kubectl -n monitor get pods --no-headers  -o custom-columns=":metadata.name")

kubectl -n monitor logs $(kubectl -n monitoring get pods --no-headers  -o custom-columns=":metadata.name")

kubectl logs -p -c ruby web-1  

