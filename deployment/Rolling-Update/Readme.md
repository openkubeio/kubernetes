# Create service 
kubectl apply -f service.yaml

# Create deployment
VERSION=1.0 \
envsubst < deployment.yaml | kubectl apply -f -

# Check deploymnet roll out status
kubectl rollout status deployment amzq

kubectl get svc

kubectl get pods

# update deploymnet
VERSION=2.0 \
envsubst < deployment.yaml | kubectl apply -f -

# Check deploymnet roll out status
kubectl rollout status deployment amz

kubectl get svc

kubectl get pods

Cleanup
-------
kubectl delete -f service.yaml

kubectl delete -f deployment.yaml