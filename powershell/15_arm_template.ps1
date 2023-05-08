$rg="armplaystuff"
$region = "eastus"
#$dnsname = "armplaystuffj34kjh3kjh"
$vmNamePrefix = "armplaystuff2"

# Create a resource group
az group create --name $rg --location $region
# Deploy the template

#$deploymentfile = "storageaccountdeploy.json"
# az deployment group create --resource-group $rg --template-file $deploymentfile --parameters storageaccountname=armplaysa9393

$deploymentfile = "vmdeploy.json"
az deployment group validate --resource-group $rg --template-file $deploymentfile

$secureUser = Read-Host "Enter user" -AsSecureString
$user = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureUser))

$securePassword = Read-Host "Enter password" -AsSecureString
$password = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword))

#az deployment group create --resource-group $rg --template-file $deploymentfile
#az deployment group create --resource-group $rg --template-file $deploymentfile --parameters adminpassword=$password
az deployment group create --resource-group $rg --template-file $deploymentfile --parameters adminpassword=$password --parameters adminuser=$user --parameters vmNamePrefix=$vmNamePrefix
az resource list --resource-group $rg --output table

#mstsc.exe /v:"$dnsname.$region.cloudapp.azure.com"
#mstsc.exe /v:"playstuffvm34ht.eastus.cloudapp.azure.com"
mstsc.exe /v:"$vmNamePrefix.$region.cloudapp.azure.com"

# Delete the resource group
az group delete --name $rg --yes --no-wait



