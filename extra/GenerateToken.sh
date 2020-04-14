#user=jenkinskubep
#namespace=jenkins

if [[ $# -lt 2 ]] ; then echo -en  "Usage... \n\n$0  --user=<user> --namepace=<namespace>\n\n" ; exit 1 ; fi

for i in $1 $2
do
case $i in
        --user=*)
                       echo $i
                       export $(echo $i  | cut -d = -f 1 | cut -c 3-)=$(echo $i  | cut -d = -f 2) ;;
        --namespace=*)
                       echo $i
                       export $(echo $i  | cut -d = -f 1 | cut -c 3-)=$(echo $i  | cut -d = -f 2) ;;
esac;
done;

#echo "user=$user"
#echo "namepace=$namespace"

[ -z "$user" ] && echo "--user not set" && exit 1
[ -z "$namespace" ] && echo "--namespace not set " && exit 1


# Create namespace in Jenkins 
[ $(kubectl get ns | awk '{print $1"~X"}' | grep ${namespace}~X | wc -l ) == 0 ] && kubectl create ns  ${namespace}

# Create Service Account for Jenkins
[ $(kubectl  get sa -n ${namespace} | awk '{print $1"~X"}' | grep ${user}~X  | wc -l ) == 0 ] && kubectl create sa ${user} -n ${namespace}


# Create rolebinding
[ $(kubectl get clusterrolebinding | grep ${user}-${namespace}-binding | wc -l ) == 0 ] && kubectl create clusterrolebinding  ${user}-binding --clusterrole cluster-admin --serviceaccount=${namespace}:${user}

# Store secret
secret=$(kubectl get sa ${user} -o jsonpath="{.secrets[*]['name']}" -n ${namespace})

# Print Secret
# echo $secret

# Store Token
token=$(kubectl get secret $secret -n ${namespace} -o jsonpath="{.data.token}")

# Print Token
# echo $token 

# Decode token to base64 –d
tokenbase64=$(echo $token | base64 -d)

# Print tokenbase64
echo $tokenbase64

echo "User  file : $(pwd)/k8s.${user}.user"
echo "Token file : $(pwd)/k8s.${user}.token"

echo ${user} > k8s.${user}.user
echo $tokenbase64 > k8s.${user}.token
