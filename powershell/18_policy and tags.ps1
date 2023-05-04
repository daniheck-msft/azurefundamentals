$rg="playstuff"
$region = "eastus"
$policyname = "playstuffpolicy"
$tagname = "playstufftag"
$tagvalue = "playstuffvalue"
$ruleFilePath = "./policy_rule.json"
$storageAccountName = "playstuffstorageaccount"

# Create a resource group
az group create --location $region --resource-group $rg

# Create a policy definition
az policy definition create --name $policyName --rules "@$ruleFilePath"

# Create a policy assignment
az policy assignment create --name $policyname --policy $policyname --resource-group $rg

# Create a storage account to test required tagging
az storage account create --name $storageAccountName --resource-group $rg --location $region --sku Standard_LRS --tags "$tagname=$tagvalue" 

# View all resources with a specific tag
az resource list --tag "$tagname=$tagvalue" --output table

# Delete the policy assignment
az policy assignment delete --name $policyname --resource-group $rg

# Delete the resource group
az group delete --name $rg --yes

# Documentation: https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/tag-resources
