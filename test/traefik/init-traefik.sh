[ -d certs ] || mkdir certs

# Create Root Key
openssl genrsa -des3 -out certs/rootCA.key 4096

# Create and self sign the Root Certificate
openssl req -x509 -new -nodes -key certs/rootCA.key -sha256 -days 1024 -out certs/rootCA.crt -subj "/C=US/ST=CA/O=My Org/CN=qa.kube.io"

# Create the certificate key
openssl genrsa -out certs/cluster.qa.kube.io.key 2048
 
# Create certificate signing request
openssl req -new -sha256 -key certs/cluster.qa.kube.io.key -subj "/C=US/ST=CA/O=My Org/OU=BU/CN=*.cluster.qa.kube.io" -out certs/cluster.qa.kube.io.csr

# Verify the csr's content
openssl req -in certs/cluster.qa.kube.io.csr -noout -text

# Create certificate
openssl x509 -req -in certs/cluster.qa.kube.io.csr -CA certs/rootCA.crt -CAkey certs/rootCA.key -CAcreateserial -out certs/cluster.qa.kube.io.crt -days 500 -sha256

# Verify the certificate's content
openssl x509 -in etc.kube.io.crt -text -noout


cat << EOF > ssl-traefik.secret.yaml
---
apiVersion: v1
kind: Secret
metadata:
  name: ssl-traefik.secret.tls
  namespace: traefik-ingress
type: kubernetes.io/tls
data:
  tls.crt: $(cat certs/cluster.qa.kube.io.crt | base64 -w0 )
  tls.key: $(cat certs/cluster.qa.kube.io.key | base64 -w0 )
---  
EOF


[[ ! $(kubectl get ns |grep traefik-ingress |awk '{ if ( $1 == "traefik-ingress" ) print $1}' | wc -l) == 1 ]] && kubectl create ns traefik-ingress


kubectl apply -f ssl-traefik.serviceaccount.yaml
kubectl apply -f ssl-traefik.clusterrole.yaml
kubectl apply -f ssl-traefik.clusterrolebinding.yaml
kubectl apply -f ssl-traefik.secret.yaml
kubectl apply -f ssl-traefik.configmap.yaml
kubectl apply -f ssl-traefik.deployment.yaml
kubectl apply -f ssl-traefik.service.yaml
kubectl apply -f ssl-traefik.service.dashboard.yaml 
kubectl apply -f ssl-traefik.ingress.dashboard.yaml

kubectl get pods -n traefik-ingress
kubectl get svc -n traefik-ingress

echo "Traefik Running on https://traefik.cluster.qa.kube.io:30001/ as on Node Port"
echo "Traefik Running on https://traefik.cluster.qa.kube.io/ as on Proxy"

traefik.cluster.qa.kube.io