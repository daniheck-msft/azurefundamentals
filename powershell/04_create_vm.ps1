# general variables 
$rg="playstuff"
$region = "eastus"
# Set variables
$vmName = "playvm"
$adminUsername = "playadmin"
#$adminPassword = "<admin-password>"
$image = "MicrosoftWindowsServer:WindowsServer:202git2-datacenter-smalldisk-g2:20348.643.220403"
$vmSize = "Standard_B2s"
$dnsname = "playstuffj34kjh3kjh"

#################################
# prep
#################################
az vm image list-publishers --location $region --query "[?contains(name, 'Microsoft')]" --output table
az vm image list --offer WindowsServer --publisher MicrosoftWindowsServer --all --output table 
az vm image list --offer WindowsServer --publisher MicrosoftWindowsServer --sku smalldisk --all --output table
az vm list-sizes --location $region --query "[?contains(name, 'B2s')]" --output table 

#################################
# create
#################################

az vm create `
  --resource-group $rg `
  --name $vmName `
  --image $image `
  --admin-username $adminUsername `
  --size $vmSize `
  --location $region `
  --public-ip-address-dns-name $dnsname
  #--admin-password <admin-password> `
  
#################################
# run cmd
#################################
# az vm run-command invoke --resource-group $rg --name $vmName --command-id RunPowerShellScript --scripts "`
# # Install IIS Server Role`
# Install-WindowsFeature -Name Web-Server -IncludeManagementTools`
# # Create default web page`
# $defaultPagePath = "C:\inetpub\wwwroot\Default.htm"`
# $defaultPageContent = "<html><body><h1>Welcome to my play website!</h1></body></html>"`
# Set-Content -Path $defaultPagePath -Value $defaultPageContent``"

az vm run-command invoke --resource-group $rg --name $vmName --command-id RunPowerShellScript --scripts "Install-WindowsFeature -Name Web-Server -IncludeManagementTools"
az vm run-command invoke --resource-group $rg --name $vmName --command-id RunPowerShellScript --scripts "Set-Content -Path 'C:\inetpub\wwwroot\Default.htm' -Value '<html><body><h1>Welcome to my play website!</h1></body></html>'"
az vm run-command invoke --resource-group $rg --name $vmName --command-id RunPowerShellScript --scripts "start http://localhost"

mstsc.exe /v:"$dnsname.$region.cloudapp.azure.com"

#################################
# delete
#################################

az vm delete --resource-group $rg --name $vmName --yes


# Documentation: https://docs.microsoft.com/en-us/azure/virtual-machines/
# Pricing: https://azure.microsoft.com/en-us/pricing/details/virtual-machines/