# Create service 
VERSION=blue  \
envsubst < service.yaml | kubectl apply -f -

# Check the service
kubectl get svc

# Create deployment
VERSION=blue \
TAG=1.0 \
envsubst < deployment.yaml | kubectl apply -f -

# Wait for it to reach a ready state
kubectl rollout status deployment amz-blue

# Create updated deployment (newer version)
VERSION=green \
TAG=2.0 \
envsubst < deployment.yaml | kubectl apply -f -

# Wait for it to become ready:
kubectl rollout status deployment amz-green

# Check the pods 
kubectl get pods 

# update  service
VERSION=green \
envsubst < service.yaml | kubectl apply -f -

