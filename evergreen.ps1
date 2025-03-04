# Ensure that the PowerShell Gallery is first trusted
if (Get-PSRepository | Where-Object { $_.Name -eq "PSGallery" -and $_.InstallationPolicy -ne "Trusted" }) {
    Install-PackageProvider -Name "NuGet" -MinimumVersion 2.8.5.208 -Force
    Set-PSRepository -Name "PSGallery" -InstallationPolicy "Trusted"
}

# Install or update Evergreen
$Installed = Get-Module -Name "Evergreen" -ListAvailable | `
    Sort-Object -Property @{ Expression = { [System.Version]$_.Version }; Descending = $true } | `
    Select-Object -First 1
$Published = Find-Module -Name "Evergreen"
if ($Null -eq $Installed) {
    Install-Module -Name "Evergreen"
}
elseif ([System.Version]$Published.Version -gt [System.Version]$Installed.Version) {
    Update-Module -Name "Evergreen"
}

mkdir "C:\temp"
Set-Location "C:\temp"
$7Zip = Get-EvergreenApp -Name 7Zip | Where-Object { $_.Architecture -eq "x64" -and $_.type -eq "msi"}
$7ZipInstaller = Split-Path -Path $7Zip.Uri -Leaf
Invoke-WebRequest -Uri $7Zip.Uri -OutFile ".\$7ZipInstaller" -UseBasicParsing
msiexec /i C:\7z2409-x64.msi /qn
