$rg = "playstuff"
$region = "eastus"
$kvname = "playstuffkv"
$keyname = "playstuffkey001"
$pemfile = "./softkey.pem"

# Create a keyvault
az keyvault create --name $kvname --resource-group $rg --location $region
# Create a key
az keyvault key create --vault-name $kvname --name $keyname --protection software
# import a key
#az keyvault key import --vault-name $kvname --name $keyname --pem-file $pemfile --protection software #--pem-password "<password>"

# Delete keyvault
az keyvault delete --name $kvname --resource-group $rg

#https://learn.microsoft.com/en-us/azure/key-vault/general/manage-with-cli2