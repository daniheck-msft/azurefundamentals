$rg="playstuff"
$region = "eastus"
$lockname = "playstufflock"

az group create --location $region --resource-group $rg
az resource list --resource-group $rg --output table

az lock create --name $lockname --lock-type CanNotDelete --resource-group $rg
az group delete --resource-group $rg --yes

az lock delete --name $lockname --resource-group $rg
az group delete --resource-group $rg --yes

# Documentation for Resource Locks: https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/lock-resources