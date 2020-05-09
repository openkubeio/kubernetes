Apply Nginx Inress Controller maintained by Kubernetes

	wet https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.26.2/deploy/static/mandatory.yaml

	Changed Replicaset to 2

	kubectl apply -f nginx-0.26.2-deploy-static-mandatory.yaml 

Create service for Ingress Controller

	kubectl apply -f nginx-0.26.2-service.yaml

Provision your Haproxy load balancer with any the the static externalIPS mentined in the service

	update the /etc/haproxy/haproxy.cfg in the server as per haproxy.cfg_http_only 

Check status of haproxy coni with below command

	haproxy -f /etc/haproxy/haproxy.cfg -c -V

You can update your externalIp with th below command

	kubectl patch svc ingress-nginx -p '{"spec":{"externalIPs":["192.168.205.18","192.168.205.19"]}}' -n ingress-nginx	

crate the dployment and ingress to test

	kubectl apply -f salad.yaml

Update your local etc/hosts to redirct the ingress host to haproxy server.

	sudo tee -a /etc/hosts  << EOF
	{
	192.168.205.18 fruit.haproxy.dv.kube.io
	192.168.205.18 vege.haproxy.dv.kube.io
	192.168.205.18 salad.haproxy.dv.kube.io
	}
	EOF

All set to test - open browser and test

	http://fruit.haproxy.dv.kube.io/apple

	http://fruit.haproxy.dv.kube.io/banana

	http://salad.haproxy.dv.kube.io/carrot



To Enabe hhtps on HAproxy server (with SSL Termination)

	Create the self signed certiicate for HAproxy to address ssl request

	[ -d mkdir /etc/haproxy/certs ] || sudo mkdir /etc/haproxy/certs

	country=US
	state=PA
	locality=PI
	organization=AU
	organizationalunit=IT
	email=administrator@myclster.net
	commonname=haproxy.dv.kube.io

	sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/haproxy/certs/$commonname.key -out /etc/haproxy/certs/$commonname.crt \
	-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"

	sudo sudo cat /etc/haproxy/certs/$commonname.key  /etc/haproxy/certs/$commonname.crt | sudo tee  /etc/haproxy/certs/$commonname.pem

	Update the /etc/haproxy/haproxy.cfg in the server as per haproxy.cfg_https_only 

check status of haproxy config with below command

	haproxy -f /etc/haproxy/haproxy.cfg -c -V

All set to test - open browser and test

	http://fruit.haproxy.dv.kube.io/apple

	https://fruit.haproxy.dv.kube.io/apple

	http://fruit.haproxy.dv.kube.io/banana

	https://fruit.haproxy.dv.kube.io/banana

	http://vege.haproxy.dv.kube.io/carrot

	https://vege.haproxy.dv.kube.io/carrot


