# Install Module Providers
Install-Module -Name Az.ManagedServiceIdentity -Scope CurrentUser
Install-Module -Name Az.ImageBuilder -Scope CurrentUser
Install-Module -Name Az.Resources -Scope CurrentUser
Install-Module -Name Az.Compute -Scope CurrentUser

# Variables
$currentAzContext = Get-AzContext
$subscriptionID=$currentAzContext.Subscription.Id
$ResourceGroup = "nncd-automation"
$time = $(get-date -UFormat "%s").Split(',')[0]
$Identity="AZUAI"+$time
$RoleDefName="Azure Image Builder Image Def"+$time
$Location="NorwayEast"
$GalleryName= "nncd"


New-AzResourceGroup -Name $ResourceGroup -Location $location
New-AzUserAssignedIdentity -ResourceGroupName $ResourceGroup -Name $Identity -Location $Location
$UAI = Get-AzUserAssignedIdentity -ResourceGroupName $ResourceGroup -Name $Identity

$RoleImageCreationUrl="https://raw.githubusercontent.com/azure/azvmimagebuilder/master/solutions/12_Creating_AIB_Security_Roles/aibRoleImageCreation.json"
$RoleImageCreationPath = "RoleImageCreation.json"
Invoke-WebRequest -Uri $RoleImageCreationUrl -OutFile $RoleImageCreationPath -UseBasicParsing

((Get-Content -path $RoleImageCreationPath -Raw) -replace '<subscriptionID>',$subscriptionID) | Set-Content -Path $RoleImageCreationPath
((Get-Content -path $RoleImageCreationPath -Raw) -replace '<rgName>', $ResourceGroup) | Set-Content -Path $RoleImageCreationPath
((Get-Content -path $RoleImageCreationPath -Raw) -replace 'Azure Image Builder Service Image Creation Role', $RoleDefName) | Set-Content -Path $RoleImageCreationPath

New-AzRoleDefinition -InputFile ./RoleImageCreation.json

New-AzRoleAssignment -ObjectId $UAI.PrincipalId -RoleDefinitionName $RoleDefName -Scope "/subscriptions/$subscriptionID/resourceGroups/$ResourceGroup"

New-AzGallery -GalleryName $GalleryName -ResourceGroupName $ResourceGroup -Location $location