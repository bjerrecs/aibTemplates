##
## Import shared variables
##
$currentAzContext = Get-AzContext
$subscriptionID=$currentAzContext.Subscription.Id
$GalleryName = "nncd"
$ResourceGroup = "nncd-automation"
$location="NorwayEast"
$imageDefName = "nncda-2503"
$templateFilePath = $imageDefName+"-Template.json"
$ADORepo = "https://raw.githubusercontent.com/bjerrecs/aibTemplates/refs/heads/main/"
$replRegion2="NorwayWest"
$runOutputName="winclientR01"

New-AzGalleryImageDefinition -GalleryName $GalleryName `
    -ResourceGroupName $ResourceGroup `
    -Location $location `
    -Name $imageDefName `
    -OsState generalized `
    -OsType Windows `
    -Publisher 'DanofficeIT' `
    -Offer 'Windows' `
    -Sku 'Win11Mu'

Invoke-WebRequest -Uri $($ADORepo+"win11ms.json") `
    -OutFile $templateFilePath -UseBasicParsing

(Get-Content -path $templateFilePath -Raw ) -replace '<subscriptionID>',$subscriptionID | Set-Content -Path $templateFilePath
(Get-Content -path $templateFilePath -Raw ) -replace '<rgName>',$ResourceGroup | Set-Content -Path $templateFilePath
(Get-Content -path $templateFilePath -Raw ) -replace '<runOutputName>',$runOutputName | Set-Content -Path $templateFilePath
(Get-Content -path $templateFilePath -Raw ) -replace '<imageDefName>',$imageDefName | Set-Content -Path $templateFilePath
(Get-Content -path $templateFilePath -Raw ) -replace '<sharedImageGalName>',$sigGalleryName | Set-Content -Path $templateFilePath
(Get-Content -path $templateFilePath -Raw ) -replace '<region1>',$location | Set-Content -Path $templateFilePath
(Get-Content -path $templateFilePath -Raw ) -replace '<region2>',$replRegion2 | Set-Content -Path $templateFilePath
((Get-Content -path $templateFilePath -Raw) -replace '<imgBuilderId>',$identityNameResourceId) | Set-Content -Path $templateFilePath


New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroup `
    -TemplateFile $templateFilePath `
    -Api-Version "2022-02-14" `
    -imageTemplateName $imageDefName `
    -svclocation $location

Invoke-AzResourceAction -ResourceName $imageDefName+"1" `
    -ResourceGroupName $ResourceGroup `
    -ResourceType Microsoft.VirtualMachineImages/imageTemplates `
    -Action Run
