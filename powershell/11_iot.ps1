$rg = "playstuff"
$region = "eastus"
$iothub = "playstuffhub"
$raspberrypi = "playstuffpi"

#az group create --name $rg --location $region
az iot hub create --name $iothub --resource-group $rg --sku S1 --location $region

#register a new device to the iot hub
az iot hub device-identity create --device-id $raspberrypi --hub-name $iothub

# Get the connection string for the device
$connectionstring = az iot hub device-identity connection-string show --device-id $raspberrypi --hub-name $iothub --output tsv
Write-Host "Device connection string:"
Write-Host $connectionstring

start "https://azure-samples.github.io/raspberry-pi-web-simulator/#GetStarted"

# Receive messages sent by the device
az iot hub monitor-events --hub-name $iothub --device-id $raspberrypi 

Exit
# delete the iot hub
az iot hub delete --name $iothub --resource-group $rg 

#https://learn.microsoft.com/en-us/azure/iot-hub/iot-hub-raspberry-pi-web-simulator-get-started
# Documentation: https://docs.microsoft.com/en-us/azure/iot-hub/
# Pricing: https://azure.microsoft.com/en-us/pricing/details/iot-hub/