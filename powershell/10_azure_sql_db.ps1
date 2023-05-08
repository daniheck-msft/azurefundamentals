$rg = "playstuff"
$region = "eastus"
$sqldb = "playstuffsqldb002"
$sqlserver = "playstuffsqlsrv002"
$adminuser ="playstuffadmin"
$so = "S0"

$securePassword = Read-Host "Enter password" -AsSecureString
$password = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword))

# Create a new resource group
#az group create --name $rg --location $region

# Create a new SQL Server
az sql server create --name $sqlserver --resource-group $rg --location $region --admin-user $adminuser --admin-password $password

# Create a new database in the smallest tier
az sql db create --name $sqldb --resource-group $rg --server $sqlserver --service-objective $so

# Set variables for the Azure SQL Server and firewall rule
$firewallRuleName="AllowMyIP"

# Get the IP address of the current host
$ipAddress = Invoke-RestMethod -Uri "http://ipinfo.io/json" | Select-Object -ExpandProperty ip
Write-Host "Your current IP address is $ipAddress"

# Add the current host's IP address to the Azure SQL Server's firewall
az sql server firewall-rule create --resource-group $rg --server $sqlserver --name $firewallRuleName --start-ip-address $ipAddress --end-ip-address $ipAddress

# Connect to the Azure SQL Server and create a new query to load the sample database
$sqlserverfqdn = az sql server show --resource-group $rg --name $sqlserver --query "fullyQualifiedDomainName" --output tsv
sqlcmd -S "tcp:$sqlserverfqdn,1433" -U $adminuser -P $password -d $sqldb -Q "CREATE TABLE Customers (CustomerID int, CustomerName varchar(255), ContactName varchar(255), Country varchar(255)); INSERT INTO Customers (CustomerID, CustomerName, ContactName, Country) VALUES (1, 'Alfreds Futterkiste', 'Maria Anders', 'Germany'), (2, 'Ana Trujillo Emparedados y helados', 'Ana Trujillo', 'Mexico'), (3, 'Antonio Moreno Taquería', 'Antonio Moreno', 'Mexico'), (4, 'Around the Horn', 'Thomas Hardy', 'UK'), (5, 'Berglunds snabbköp', 'Christina Berglund', 'Sweden');"
sqlcmd -S "tcp:$sqlserverfqdn,1433" -U $adminuser -P $password -d $sqldb -Q "SELECT * FROM Customers;" 

# Clean up deployment
az sql db delete --resource-group $rg --server $sqlserver --name $sqldb --yes
az sql server delete --resource-group $rg --name $sqlserver --yes

# Documentation: https://docs.microsoft.com/en-us/azure/azure-sql/database/
# Pricing: https://azure.microsoft.com/en-us/pricing/details/azure-sql-database/
