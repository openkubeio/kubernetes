### Overview
Demo to collect the container logs with fluentd and shiping them to mongo DB for visualization and analysis.
Scope includes building fluentd docker image to support out flow of logs to Mongo DB and creating Fluentd conf to source, filter and match the output to Mongo


### Build fluentd image 

Gathering logs from kubernetes platform would require fluent kubernetes daemonset image which has preinstalled kubernetes filter and metadata parser
plugins that fetches information like podID, namespace, nodeName etc.
Unfortunately, fluentd-kubernetes-daemonset doesn't have any tags available for mongo. So we are going to create one for our own.

```
docker build . -t openkubeio/fluend-kubernetes:v1.9-debian-mongo
```

### Setup up mongo db and web client
```
kubectl apply -f mongo.stateful.standalone.yaml
kubectl apply -f mongo.client.yaml
```

### Set up fluentd daemonset and fluent config map
```
kubectl apply -f fluent-cm.yaml
kubectl apply -f fluent-ds.yaml
kubectl get pods -A  -l k8s-app=fluentd-logging -o wide 
```

### Reference
Below are the link to the official fluentd-kubernetes-daemonset yamls and docker repository for more insight

> https://github.com/fluent/fluentd-kubernetes-daemonset/tree/master/docker-image/v1.9/debian-forward
> https://github.com/fluent/fluent-plugin-mongo






