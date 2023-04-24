$rg="playstuff"
$region = "eastus"

###############################
# create
###############################
az group create --location $region --resource-group $rg

###############################
# List resources in RG
###############################
az resource list --resource-group $rg --output table

###############################
# delete
###############################
az group delete --resource-group $rg --yes

