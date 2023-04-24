$rg="playstuff"
$region = "eastus"

###############################
# create
###############################
az group create --location $region --resource-group $rg

###############################
# delete
###############################
az group delete --location $region --resource-group $rg

