kubectl create ns monitoring

kubectl create configmap prometheus-server-conf --from-file prometheus.config -n monitoring

kubectl apply -f rbac.yaml
kubectl apply -f prometheus-deployment.yaml
kubectl apply -f prometheus-service.yaml
kubectl apply -f prometheus-ingress.yaml




kubectl delete configmap prometheus-server-conf  -n monitoring
kubectl delete deploy prometheus-deployment -n monitoring

DEBUG
-----
kubectl -n monitoring get pods 
kubectl -n monitoring get pods --no-headers  -o custom-columns=":metadata.name" 

kubectl -n monitoring describe pod $(kubectl -n monitoring get pods --no-headers  -o custom-columns=":metadata.name")

kubectl -n monitoring logs $(kubectl -n monitoring get pods --no-headers  -o custom-columns=":metadata.name")

kubectl logs -p -c ruby web-1  

