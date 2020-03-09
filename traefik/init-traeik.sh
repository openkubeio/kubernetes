cat << EOF >> ssl-traefik.secret.tls.yaml
---
apiVersion: v1
kind: Secret
metadata:
  name: traefik.mycluster.net.tls
  namespace: default
type: kubernetes.io/tls
data:
  tls.crt: $(cat certs/local.crt | base64 -w0 )
  tls.key: $(cat certs/local.key | base64 -w0 )
---  
EOF


[ $(kubectl get ns | grep traefik | wc -l) !=1 ] && kubectl create ns traefik 

kubectl apply -f ssl-traefik.serviceaccount.yaml
kubectl apply -f ssl-traefik.custerrole.yaml
kubectl apply -f ssl-traefik.clusterrolebinding.yaml
kubectl apply -f ssl-traefik.secret.tls.yaml
kubectl apply -f ssl-traefik.configmap.yaml
kubectl apply -f ssl-traefik.deployment.yaml
kubectl apply -f ssl-traefik.service.yaml
kubectl apply -f ssl-traefik.service.dashboard.yaml 
kubectl apply -f ssl-traefik.ingress.dashboard.yaml

echo "Traeik Running on 