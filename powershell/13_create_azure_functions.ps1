$rg="playstuff"
$region = "eastus"
$sa = "playstuffasjklhedi8732"
$appname = "playstufffuncapp"

# In a terminal or command window, run func --version to check that the Azure Functions Core Tools are version 4.x.
# npm i -g azure-functions-core-tools@4 --unsafe-perm true
choco install azure-functions-core-tools #run elevated
func --version
# Run dotnet --list-sdks to check that the required versions are installed.
winget install Microsoft.DotNet.SDK.6
dotnet --list-sdks 
# Run az --version to check that the Azure CLI version is 2.4 or later.
# az --version
# Run az login to sign in to Azure and verify an active subscription.
# az login

# create a new function app
func init LocalFunctionProj --dotnet --force
cd LocalFunctionProj
func new --name HttpExample --template "HTTP trigger" --authlevel "anonymous"

#start the function app locally
func start
start "http://localhost:7071/api/HttpExample"

# prepare infrastructure in Azure for deployment
az storage account create --name $sa --location $region --resource-group $rg --sku Standard_LRS --allow-blob-public-access false
az functionapp create --resource-group $rg --consumption-plan-location $region --runtime dotnet --functions-version 4 --name $appname --storage-account $sa

# deploy the function app to Azure
func azure functionapp publish $appname
start "https://$appname.azurewebsites.net/api/HttpExample?name=Functions"
func azure functionapp logstream $appname

#clean up
az resource list --resource-group $rg --output table

az functionapp delete --name $appname --resource-group $rg
az storage account delete --name $sa --resource-group $rg --yes
