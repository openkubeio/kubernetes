# Create service 
envsubst < service.yaml | kubectl apply -f -

# Check the service
kubectl get svc


host_entry="192.168.205.13 amz.dv.kube.io"
if [ $(cat /C/Windows/System32/drivers/etc/hosts | grep "$host_entry" | wc -l ) == 0  ] ; then
echo $host_entry >> /C/Windows/System32/drivers/etc/hosts 
fi;



# Create deployment version Blue  pods
VERSION=blue \
TAG=1.0 \
envsubst < deployment.yaml | kubectl apply -f -

# Wait for it to reach a ready state
kubectl rollout status deployment amz-blue


# check https://amz.dv.kube.io/
Hello, world!
Version: 1.0.0
Hostname: amz-blue-c669cd69b-hkkvj



# Create new version Green pods
VERSION=green \
TAG=2.0 \
envsubst < deployment.yaml | kubectl apply -f -

# Wait for it to become ready:
kubectl rollout status deployment amz-green


# Check the pods ; boths blue and green set of pods are available and Running
kubectl get pods 


# acess application



# update service by uncommenting annotation  to switch sticky session
VERSION=green \
envsubst < service.yaml | kubectl apply -f -

