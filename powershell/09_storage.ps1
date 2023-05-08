$rg = "playstuff"
$region = "eastus"
$sa = "playstuffsa0815"
$container = "playstuffcontainer"
$filename = "helloblob.txt"

#az group create --name $rg --location $region
az storage account create --name $sa --location $region --resource-group $rg --sku Standard_LRS --kind StorageV2 --access-tier Hot
$accountKey = az storage account keys list --account-name $sa --resource-group $rg --query "[0].value" --output tsv
az storage container create --name $container --account-name $sa --account-key $accountKey
az storage blob upload --account-name $sa --account-key $accountKey --container-name $container --type block --name $filename --file ".\$filename"
az storage blob list --account-name $sa --account-key $accountKey --container-name $container --output table
az storage blob download --account-name $sa --account-key $accountKey --container-name $container --name $filename --file $"$filename.bak"

#clean up
az storage blob delete --account-name $sa --account-key $accountKey --container-name $container --name $filename
az storage container delete --account-name $sa --account-key $accountKey --name $container
az storage account delete --name $sa --resource-group $rg --yes

az storage account list --resource-group $rg --output table

# Documentation: https://docs.microsoft.com/en-us/azure/storage/
# Pricing: https://azure.microsoft.com/en-us/pricing/details/storage/
