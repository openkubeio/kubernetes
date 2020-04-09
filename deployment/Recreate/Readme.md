kubectl apply -f my-app-service.yaml 

# Create deployment
VERSION=1.0 \
envsubst < my-app-deployment.yaml | kubectl apply -f -

kubectl get pods

# Create deployment
VERSION=2.0 \
envsubst < my-app-deployment.yaml | kubectl apply -f -