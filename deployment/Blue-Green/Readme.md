# Create service 
VERSION=blue  \
envsubst < service.yaml | kubectl apply -f -

# Check the service
kubectl get svc

# Create deployment version Blue  pods
VERSION=blue \
TAG=1.0 \
envsubst < deployment.yaml | kubectl apply -f -

# Wait for it to reach a ready state
kubectl rollout status deployment amz-blue

# Create new version Green pods
VERSION=green \
TAG=2.0 \
envsubst < deployment.yaml | kubectl apply -f -

# Wait for it to become ready:
kubectl rollout status deployment amz-green

# Check the pods ; boths blue and green set of pods are available and Running
kubectl get pods 

# update service to switch to green pods
VERSION=green \
envsubst < service.yaml | kubectl apply -f -

Take down blue pods  on success switch
kubectl delete deployment amz-blue