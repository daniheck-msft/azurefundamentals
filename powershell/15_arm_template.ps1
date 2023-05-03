$rg="armplaystuff"
$region = "eastus"
$deploymentfile = "storageaccountdeploy.json"

# Create a resource group
az group create --name $rg --location $region
# Deploy the template
az deployment group create --resource-group $rg --template-file $deploymentfile --parameters storageaccountname=armplaysa9393
az resource list --resource-group $rg --output table

# Delete the resource group
az group delete --name $rg --yes --no-wait



