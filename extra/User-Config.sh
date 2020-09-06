kubectl config set-cluster kubernetes --server=https://192.168.210.10:6443 --insecure-skip-tls-verify=true
kubectl config set-credentials employee --client-certificate=/c/Users/Pramode/employee.crt  --client-key=/c/Users/Pramode/employee.key
kubectl config set-context employee-context --cluster=kubernetes --namespace=office --user=employee
kubectl config use-context employee-context