kubectl create configmap  nginx-default-conf --from-file=default.conf

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout nginx.key -out nginx.crt -subj "/CN=nginxsvc/O=nginxsvc"

kubectl create secret tls nginxsecret --key nginx.key --cert nginx.crt

kubectl apply -f nginx.deploy.yaml


https://github.com/kubernetes/examples/blob/master/staging/https-nginx/Makefile 