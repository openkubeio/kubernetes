country=US
state=PA
locality=PI
organization=AU
organizationalunit=IT
email=administrator@myclster.net
commonname=grafana.traefik.io

sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -reqexts v3_req -extensions v3_ca \
-keyout /etc/mycerts/$commonname.key -out /etc/mycerts/$commonname.crt \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"


kubectl create secret tls ca-key-pair \
   --cert=/etc/mycerts/$commonname.crt \
   --key=/etc/mycerts/$commonname.key \
   --namespace=monitor
 
 
apiVersion: cert-manager.io/v1alpha2
kind: Issuer
metadata:
  name: ca-issuer
  namespace: default
spec:
  ca:
    secretName: ca-key-pair

	
 
apiVersion: cert-manager.io/v1alpha2
kind: Certificate
metadata:
  name: example-com
  namespace: default
spec:
  secretName: example-com-tls
  issuerRef:
    name: ca-issuer
    # We can reference ClusterIssuers by changing the kind here.
    # The default value is Issuer (i.e. a locally namespaced Issuer)
    kind: Issuer
  commonName: example.com
  organization:
  - Example CA
  dnsNames:
  - example.com
  - www.example.com  
   