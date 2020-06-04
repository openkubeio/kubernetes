if [[ $# -lt 1 ]] ; then echo -en  "Usage... \n\n$0  <namespace>\n\n" ; exit 1 ; fi

export namespace=$1

svc_data=$(kubectl get svc -n $namespace  -o json)

echo $svc_data | jq -r '.items[] | "\(.metadata.name)\t\(.spec.type)\t\(.spec.ports[] .nodePort)\t\(.spec.selector)"' | grep NodePort | sed 's/:/=/g' | sed 's/["{}]//g'  >  svc_selectors.dat

cat svc_selectors.dat | while read line 
do
   #echo $line
   selector=$(echo $line | cut -d" " -f4)
   #echo $selector
   
   pod_data=$(kubectl get pods -n $namespace --selector=$svc_selector -o json)
   echo $pod_data | jq -r '.items[] | "\(.metadata.name) \(.status.phase) \(.spec.nodeName) "'  | xargs -i echo "{} $(echo $line | cut -d' ' -f-3)"
   
done
