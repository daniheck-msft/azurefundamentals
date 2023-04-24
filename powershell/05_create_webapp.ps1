# general variables 
$rg="playstuff"
$region = "eastus"
$webappname = "myPlayWebApp"
$appplanname = "playAppPlan"

#########################################
# Sample Get App 
#########################################
git clone https://github.com/Azure-Samples/html-docs-hello-world.git
cd html-docs-hello-world

#########################################
# Create RG 
#########################################
az group create --location $region --resource-group $rg

#########################################
# Deploy Web App including AppPlan
#########################################
az webapp up --location $region --name $webappname --resource-group $rg --plan $appplanname --html --sku F1 -b

#########################################
# Delete Web App including AppPlan
#########################################
az webapp delete --name $webappname --resource-group $rg 
az appservice plan delete --resource-group $rg --name $appplanname --yes

###############################
# List resources in RG
###############################
az resource list --resource-group $rg --output table