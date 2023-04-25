$rg = "playstuff"
$aks = "daniheckaks363"
$acr = "daniheckacr363"
$image = "mcr.microsoft.com/azuredocs/aci-helloworld"
$deploymentname = "aci-helloworld"

#create acr
az group list --output table
#az group create --name $rg --location $location
az acr create --resource-group $rg --name $acr --sku Basic
az acr login --name $acr

#create aks
az aks create --resource-group $rg --name $aks --node-count 2 --generate-ssh-keys --attach-acr $acr
#az aks update -n $aks -g $rg --attach-acr $acr
az aks get-credentials --resource-group $rg --name $aks
kubectl get nodes

#create a deployment
kubectl create deployment $deploymentname --image=$image 
kubectl expose deployment $deploymentname --type=LoadBalancer --port=80 --target-port=80
kubectl get service $deploymentname #--watch
$ip = kubectl get service $deploymentname --output jsonpath='{.status.loadBalancer.ingress[0].ip}'
start "http://$ip"

kubectl delete deployment $deploymentname
kubectl delete service $deploymentname
#kubectl delete pod $deploymentname

#delete aks and acr
az aks delete --name $aks --resource-group $rg --yes --no-wait
az acr delete --name $acr --resource-group $rg --yes 

#destroy everything
az group delete --name $rg --yes --no-wait

