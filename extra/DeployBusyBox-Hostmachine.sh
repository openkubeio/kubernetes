
https://medium.com/lucjuggery/a-container-to-access-the-shell-of-the-host-2c7c227c64e9

docker run --privileged --pid=host -it alpine:3.8 \
nsenter -t 1 -m -u -n -i /bin/sh

https://twpower.github.io/178-run-container-as-privileged-mode-en

https://docs.bitnami.com/tutorials/configure-rbac-in-your-kubernetes-cluster/

https://medium.com/coryodaniel/kubernetes-assigning-pod-security-policies-with-rbac-2ad2e847c754

https://stackoverflow.com/questions/55707978/can-a-pod-security-policy-be-applied-to-a-namespace

https://thenewstack.io/tutorial-create-a-kubernetes-pod-security-policy/

https://kubernetes.io/docs/concepts/policy/pod-security-policy/

kubectl config set-cluster kubernetes --server=https://192.168.210.10:6443 --insecure-skip-tls-verify=true
kubectl config set-credentials employee --client-certificate=/c/Users/Pramode/employee.crt  --client-key=/c/Users/Pramode/employee.key
kubectl config set-context employee-context --cluster=kubernetes --namespace=office --user=employee
kubectl config use-context employee-context

kubectl auth can-i use podsecuritypolicy/restrict-root