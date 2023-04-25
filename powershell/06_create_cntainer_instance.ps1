# general variables 
$rg="playstuff"
$region = "eastus"
$containername = "myplaycontainer"
$image = "mcr.microsoft.com/azuredocs/aci-helloworld"
$dns = "acidemo9fsdlj9"
$port = "80"

#Create RG
az group create --name $rg --location $region

#Create container
az container create --resource-group $rg --name $containername --image $image --dns-name-label $dns --ports $port

#check deployment status
az container show --resource-group $rg --name $containername --query "{FQDN:ipAddress.fqdn,ProvisioningState:provisioningState}" --out table

#browse to FGDN
start http://acidemo9fsdlj9.eastus.azurecontainer.io

#Get logs
az container logs --resource-group $rg --name $containername

#Attach output streams
az container attach --resource-group $rg --name $containername

#delete container
az container delete --resource-group $rg --name $containername --yes

#delete RG
#az group delete --resource-group $rg --yes