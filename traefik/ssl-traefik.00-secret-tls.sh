[ -d mkdir /etc/mycerts ] || sudo mkdir /etc/mycerts

country=US
state=PA
locality=PI
organization=AUd
organizationalunit=IT
email=administrator@myclster.net
commonname=*.traefik.mycluster.net


sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
-keyout /etc/mycerts/$commonname.key -out /etc/mycerts/$commonname.crt \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"


kubectl -n traefik-ingress create secret tls traefik.mycluster.net.tls \
--cert=/etc/mycerts/$commonname.crt \
--key=/etc/mycerts/$commonname.key
 

 
#  ====creating ts secret usin yaml==========
#  
#  cat << EOF >> ssl-traefik.secret.yaml
#  ---
#  apiVersion: v1
#  kind: Secret
#  metadata:
#    name: traefik.mycluster.net.tls
#    namespace: default
#  type: kubernetes.io/tls
#  data:
#    tls.crt: $(cat /etc/mycerts/$commonname.crt | base64 -w0 )
#    tls.key: $(cat /etc/mycerts/$commonname.key | base64 -w0 )
#  ---  
#  EOF
#  
#  kubectl apply -f ssl-traefik.secret.yaml
#  
#  ===========================================

  
