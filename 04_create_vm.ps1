# general variables 
$rg="playstuff"
$region = "eastus"
$sa = "allianzasjklhedi8732"

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
  
mstsc.exe /v:"$dnsname.$region.cloudapp.azure.com"

  
#################################
# delete
#################################

az vm delete --resource-group $rg --name $vmName --yes