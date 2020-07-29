https://docs.traefik.io/v2.0/middlewares/headers/

https://docs.traefik.io/v2.0/middlewares/headers/#cors-headers

https://docs.traefik.io/routing/providers/kubernetes-crd/#kind-ingressroute

https://docs.traefik.io/routing/providers/kubernetes-crd/

https://docs.traefik.io/routing/providers/kubernetes-ingress/

https://www.infoq.com/news/2019/11/traefik-routing-release/

https://hub.helm.sh/charts/dniel/traefik

https://docs.traefik.io/v1.6/configuration/backends/kubernetes/

https://stackoverflow.com/questions/53824313/get-request-on-docker-traefik-api-block-by-cors-rules




################# CRD Ingress Route : Middleware ###########

cat <<EOF | kubectl apply -f -	
apiVersion: apiextensions.k8s.io/v1beta1
kind: CustomResourceDefinition
metadata:
  name: middlewares.traefik.containo.us
spec:
  group: traefik.containo.us
  version: v1alpha1
  names:
    kind: Middleware
    plural: middlewares
    singular: middleware
  scope: Namespaced
EOF 


cat <<EOF | kubectl apply -f -	
apiVersion: apiextensions.k8s.io/v1beta1
kind: CustomResourceDefinition
metadata:
  name: ingressroutes.traefik.containo.us

spec:
  group: traefik.containo.us
  version: v1alpha1
  names:
    kind: IngressRoute
    plural: ingressroutes
    singular: ingressroute
  scope: Namespaced
EOF



############### Middleware ######################

cat <<EOF | kubectl apply -f -		  
apiVersion: traefik.containo.us/v1alpha1
kind: Middleware
metadata:
  name: test-header
spec:
  headers:
    stsSeconds: 15768000
    customRequestHeaders:
      X-Script-Name: "test" 
    accessControlAllowMethods:
      - "GET"
      - "OPTIONS"
      - "PUT"
    accessControlAllowOrigin: "*"
    accessControlMaxAge: 100
    Access-Control-Allow-Headers: "Origin, X-Requested-With, Content-Type, Accept"	 
    addVaryHeader: true
---
apiVersion: traefik.containo.us/v1alpha1
kind: Middleware
metadata:
  name: stripprefix
spec:
  stripPrefix:
    prefixes:
      - /stripit

EOF


############### Ingress Route ######################

cat <<EOF | kubectl apply -f -	
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: ingressroutescorsenable
spec:
  entryPoints:
    - web
  routes:
#   - match: Host('whoami.dv.kube.io')
    - kind: Rule
      services:
        - name: whoami
          port: 80
      middlewares:
        - name: test-header
EOF

############# Ingress #########################

cat <<EOF | kubectl apply -f -	
kind: Ingress
apiVersion: extensions/v1beta1
metadata:
  name: myingress
  annotations:
#   traefik.ingress.kubernetes.io/router.entrypoints: web
#   traefik.ingress.kubernetes.io/router.middlewares: default-test-header@kubernetescrd
#   name: myingress
#   namespace: default
    kubernetes.io/ingress.class: traefik
    ingress.kubernetes.io/custom-request-headers: 'accessControlAllowOrigin: \"*\"'
    ingress.kubernetes.io/custom-request-headers: 'Access-Control-Allow-Headers: \"Origin, X-Requested-With, Content-Type, Accept\"'
spec:
  rules:
    - host: whoami.dv.kube.io
      http:
        paths:
          - path: /bar
            backend:
              serviceName: whoami
              servicePort: 80
          - path: /foo
            backend:
              serviceName: whoami
              servicePort: 80
EOF


################# Deployment and Service ############

cat <<EOF | kubectl apply -f -		
kind: Deployment
apiVersion: apps/v1
metadata:
  name: whoami
  namespace: default
  labels:
    app: containous
    name: whoami
spec:
  replicas: 2
  selector:
    matchLabels:
      app: containous
      task: whoami
  template:
    metadata:
      labels:
        app: containous
        task: whoami
    spec:
      containers:
        - name: containouswhoami
          image: containous/whoami
          ports:
            - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: whoami
  namespace: default
spec:
  ports:
    - name: http
      port: 80
  selector:
    app: containous
    task: whoami
EOF
		
		