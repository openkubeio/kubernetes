##https://github.com/etcd-io/etcd/blob/master/Documentation/op-guide/recovery.md#restoring-a-cluster


docker run --name backup --rm -e "ETCDCTL_API=3" k8s.gcr.io/etcd:3.4.3-0 etcdctl version

$ ETCDCTL_API=3 etcdctl --endpoints $ENDPOINT snapshot save snapshot.db
 

cat << EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: etcd-box
  namespace: kube-system
spec:
  containers:
  - image: k8s.gcr.io/etcd:3.4.3-0
    command:
      - sleep
      - "3600"
    name: test-container
    imagePullPolicy: IfNotPresent	
    volumeMounts:
    - mountPath: /etc/kubernetes/pki/etcd
      name: test-volume
  volumes:
  - name: test-volume
    hostPath:
      # directory location on host
      path: /etc/kubernetes/pki/etcd
      # this field is optional
      type: Directory
EOF	  	  

kubectl get nodes -o json | jq .items[].spec.taints