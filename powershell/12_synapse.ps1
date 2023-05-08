$rg = "playstuff"
$region = "eastus"
$workspaceName = "playstuffsynapse"
$sa = "playstuffsa0815"
$fileSystemName = "playstufffs"
$adminUsername = "playstuffadmin"
$container = "greentaxidata"
#################
$url = "https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2023-01.parquet"
$outputFilePath = "C:\temp\NYCTripSmall.parquet"
#################
$securePassword = Read-Host "Enter password" -AsSecureString
$password = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword))

#az storage account create --name $sa --location $region --resource-group $rg --sku Standard_LRS --kind StorageV2 --access-tier Hot

az synapse workspace create `
    --name $workspaceName `
    --resource-group $rg `
    --storage-account $sa `
    --file-system $fileSystemName `
    --sql-admin-login-user $adminUsername `
    --sql-admin-login-password $password `
    --location $region `
    
$ipAddress = Invoke-RestMethod -Uri "http://ipinfo.io/json" | Select-Object -ExpandProperty ip
Write-Host "Your current IP address is $ipAddress"

az synapse workspace firewall-rule create --name "AllowMyIp" --workspace-name $workspaceName --resource-group $rg --start-ip-address $ipAddress --end-ip-address $ipAddress
    
# Get the workspace endpoints
$WorkspaceWeb=$(az synapse workspace show --name $workspaceName --resource-group $rg | jq -r '.connectivityEndpoints | .web')
$WorkspaceDev=$(az synapse workspace show --name $workspaceName --resource-group $rg | jq -r '.connectivityEndpoints | .dev')
Write-Host "Workspace Web URL: $WorkspaceWeb"
Write-Host "Workspace Dev URL: $WorkspaceDev"

Exit
# Clean up deployment
az synapse workspace delete --name $workspaceName --resource-group $rg --yes

##############################################
#https://learn.microsoft.com/en-us/azure/synapse-analytics/get-started
#https://docs.microsoft.com/en-us/azure/synapse-analytics/quickstart-create-workspace-cli
##############################################


####################################

# #Invoke-WebRequest -Uri $url -OutFile $outputFilePath
    
# # Upload sample data to the workspace
# start "https://web.azuresynapse.net/en/workspaces"

# az storage account create --name $sa --resource-group $rg --location $region --sku Standard_LRS

# $connectionString = (az storage account show-connection-string --name $sa --query connectionString -o tsv)
# Write-Host "Connection string: $connectionString"

# az storage container create --name $container --connection-string $connectionString
    
# Invoke-WebRequest -Uri $url -OutFile $outputFilePath

# $key = az storage account keys list --account-name $sa --resource-group $rg --query "[0].value" --output tsv
# Write-Host "Storage account key: $key"

# $outputFile = Split-Path $outputFilePath -Leaf
# Write-Host "The filename is: $outputFile"
# az storage blob upload --account-name $sa --account-key $key --container-name $container --type block --name $outputFile --file $outputFilePath