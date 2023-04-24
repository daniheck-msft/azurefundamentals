# Set variables for the resource group, app name, and $region
$rg="playstuff"
$region = "eastus"
$appName = "myPlayWebApp"

# Create a resource group
az group create --name $rg --$region $$region

# Create a web app
az webapp create --name $appName --resource-group $rg --plan myAppServicePlan --runtime "DOTNET|5.0" --deployment-local-git

# Deploy a sample web page
git clone https://github.com/Azure-Samples/dotnetcore-sqldb-tutorial.git
cd dotnetcore-sqldb-tutorial
az webapp deployment source config-local-git --name $appName --resource-group $rg --query url --output tsv
git remote add azure <url-from-previous-command>
git push azure master