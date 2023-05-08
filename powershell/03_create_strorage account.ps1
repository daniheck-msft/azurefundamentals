$rg="playstuff"
$region = "eastus"
$sa = "allianzasjklhedi8732"

az storage account create --name $sa --resource-group $rg --location $region --sku Standard_LRS --kind StorageV2

az resource list --resource-group $rg --output table

az storage account delete --name $sa --resource-group $rg -y


# Documentation: https://docs.microsoft.com/en-us/azure/storage/
# Pricing: https://azure.microsoft.com/en-us/pricing/details/storage/