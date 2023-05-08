$rg = "playstuff"
$region = "eastus"
$pip = "playstuffpip"
$vnetgw = "vnetGateway"
$vnet = "vnet"

#az group create --name $rg --location $region
az network vnet create --name $vnet --resource-group $rg --address-prefixes 10.0.0.0/16 --subnet-name GatewaySubnet --subnet-prefixes 10.0.1.0/24
az network public-ip create --name $pip --resource-group $rg --allocation-method Dynamic
az network vnet-gateway create --name $vnetgw  --public-ip-address $pip --resource-group $rg --vnet $vnet --gateway-type Vpn --sku VpnGw1 --vpn-type RouteBased

az network vnet-gateway list --resource-group $rg --output table

az resource list --resource-group $rg --output table

#clean up
az network vnet-gateway delete --name $vnetgw --resource-group $rg
az network public-ip delete --name $pip --resource-group $rg
az network vnet delete --name $vnet --resource-group $rg

az resource list --resource-group $rg --output table

# Documentation: https://docs.microsoft.com/en-us/azure/virtual-network/
# Pricing: https://azure.microsoft.com/en-us/pricing/details/virtual-network/