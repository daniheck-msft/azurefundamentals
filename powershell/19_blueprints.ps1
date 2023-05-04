# Add the Blueprint extension to the Azure CLI environment
az extension add --name blueprint

# Check the extension list (note that you might have other extensions installed)
az extension list

# Run help for extension options
az blueprint -h

# Create the blueprint object
az blueprint create `
   --name 'MyBlueprint' `
   --description 'This blueprint sets tag policy and role assignment on the subscription, creates a ResourceGroup, and deploys a resource template and role assignment to that ResourceGroup.' `
   --parameters blueprintparms.json

# Add the resource group for the storage artifacts to the definition.
az blueprint resource-group add `
    --blueprint-name 'MyBlueprint' `
    --artifact-name 'storageRG' `
    --description 'Contains the resource template deployment and a role assignment.'

# Add a role assignment at the subscription. 
az blueprint artifact policy create `
    --blueprint-name 'MyBlueprint' `
    --artifact-name 'policyTags' `
    --policy-definition-id '/providers/Microsoft.Authorization/policyDefinitions/49c88fc8-6fd1-46fd-a676-f12d1d3a4c71' `
    --display-name 'Apply tag and its default value to resource groups' `
    --description 'Apply tag and its default value to resource groups' `
    --parameters "artifacts`policyTags.json"

# Add another policy assignment for the storage tag (by reusing storageAccountType_ parameter) at the subscription.
az blueprint artifact policy create `
   --blueprint-name 'MyBlueprint' `
   --artifact-name 'policyStorageTags' `
   --policy-definition-id '/providers/Microsoft.Authorization/policyDefinitions/49c88fc8-6fd1-46fd-a676-f12d1d3a4c71' `
   --display-name 'Apply storage tag to resource group' `
   --description 'Apply storage tag and the parameter also used by the template to resource groups' `
   --parameters "artifacts\policyStorageTags.json"

# Add a template under resource group. The template parameter for an ARM template includes the normal JSON components of the template. 
az blueprint artifact template create `
   --blueprint-name 'MyBlueprint' `
   --artifact-name 'templateStorage' `
   --template "artifacts\templateStorage.json" `
   --parameters "artifacts\templateStorageParams.json" `
   --resource-group-art 'storageRG'

# Add a role assignment under the resource group. 
az blueprint artifact role create `
    --blueprint-name "MyBlueprint" `
    --artifact-name "roleOwner" `
    --role-definition-id "/providers/Microsoft.Authorization/roleDefinitions/8e3af657-a8ff-443c-a75c-2fe8c4bcb635" `
    --principal-ids "`"[parameters('owners')]`"" `
    --resource-group-art "storageRG"

# Publish the blueprint
az blueprint publish --blueprint-name 'MyBlueprint' --version 'v1092872876'

# Assign the blueprint
az blueprint assignment create `
   --name 'assignMyBlueprint' `
   --location 'westus' `
   --resource-group-value artifact_name=storageRG name=StorageAccount location=eastus `
   --parameters blueprintAssignment.json

# List the blueprints
az blueprint list --query "[].{name:name, id:id}"

# Clean up blueprint
az blueprint assignment delete --name 'assignMyBlueprint' --yes


