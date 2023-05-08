# Install IIS Server Role
Install-WindowsFeature -Name Web-Server -IncludeManagementTools

# Create default web page
$defaultPagePath = "C:\inetpub\wwwroot\Default.htm"
$defaultPageContent = "<html><body><h1>Welcome to my website!</h1></body></html>"
Set-Content -Path $defaultPagePath -Value $defaultPageContent

