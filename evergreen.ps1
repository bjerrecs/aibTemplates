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

# 7-Zip
$7zip = Get-EvergreenApp -Name "7zip" | Where-Object { $_.Architecture -eq 'x64' -and $_.Type -eq 'msi'}
$7zipInstaller = $7zip | Save-EvergreenApp -Path "C:\Temp\7zip"
C:\windows\System32\msiexec.exe /package $($7zipInstaller.FullName) ALLUSER=1 ALLUSERS=1 /quiet

# Python3
$Python = Get-EvergreenApp -Name "Python" | Where-Object { $_.Python -eq 3 -and $_.Architecture -eq 'x64'}
$PythonInstaller = $Python | Save-EvergreenApp -Path "C:\Temp\Python"
C:\windows\System32\msiexec.exe /package $($PythonInstaller.FullName) ALLUSER=1 ALLUSERS=1 /quiet

#PuTTY
$PuTTY = Get-EvergreenApp -Name "PuTTY" | Where-Object Architecture -eq 'x64'
$PuTTYInstaller = $PuTTY | Save-EvergreenApp -Path "C:\Temp\PuTTY"
C:\windows\System32\msiexec.exe /package $($PuTTYInstaller.FullName) ALLUSER=1 ALLUSERS=1 /quiet

# Postman
$Postman = Get-EvergreenApp -Name "Postman" | Where-Object Architecture -eq 'x64'
$PostmanInstaller = $Postman | Save-EvergreenApp -Path "C:\Temp\Postman"
C:\windows\System32\msiexec.exe /package $($PostmanInstaller.FullName) ALLUSER=1 ALLUSERS=1 /quiet

# NotepadPlusPlus
$NotepadPlusPlus = Get-EvergreenApp -Name "NotepadPlusPlus" | Where-Object { $_.Architecture -eq 'x64' -and $_.InstallerType -eq 'default'}
$NotepadPlusPlusInstaller = $NotepadPlusPlus | Save-EvergreenApp -Path "C:\Temp\NotepadPlusPlus"
C:\windows\System32\msiexec.exe /package $($NotepadPlusPlusInstaller.FullName) ALLUSER=1 ALLUSERS=1 /quiet

# MicrosoftVisualStudioCode
$MicrosoftVisualStudioCode = Get-EvergreenApp -Name "MicrosoftVisualStudioCode" | Where-Object { $_.Architecture -eq 'x64' -and $_.Channel -eq 'stable' -and $_.Platform -eq "win32-x64"}
$MicrosoftVisualStudioCodeInstaller = $MicrosoftVisualStudioCode | Save-EvergreenApp -Path "C:\Temp\MicrosoftVisualStudioCode"
C:\windows\System32\msiexec.exe /package $($MicrosoftVisualStudioCodeInstaller.FullName) ALLUSER=1 ALLUSERS=1 /quiet

# MicrosoftSsms
$MicrosoftSsms = Get-EvergreenApp -Name "MicrosoftSsms" | Where-Object { $_.Language -eq 'English'}
$MicrosoftSsmsInstaller = $MicrosoftSsms | Save-EvergreenApp -Path "C:\Temp\MicrosoftSsms"
C:\windows\System32\msiexec.exe /package $($MicrosoftSsmsInstaller.FullName) ALLUSER=1 ALLUSERS=1 /quiet

# OracleJava8
$OracleJava8 = Get-EvergreenApp -Name "OracleJava8" | Where-Object { $_.Architecture -eq 'x64'}
$OracleJava8Installer = $OracleJava8 | Save-EvergreenApp -Path "C:\Temp\OracleJava8"
C:\windows\System32\msiexec.exe /package $($OracleJava8Installer.FullName) ALLUSER=1 ALLUSERS=1 /quiet

# GoogleChrome
$GoogleChrome = Get-EvergreenApp -Name "GoogleChrome" | Where-Object { $_.Architecture -eq 'x64' -and $_.Type -eq 'msi' -and $_.Channel -eq "Stable"}
$GoogleChromeInstaller = $GoogleChrome | Save-EvergreenApp -Path "C:\Temp\GoogleChrome"
C:\windows\System32\msiexec.exe /package $($GoogleChromeInstaller.FullName) ALLUSER=1 ALLUSERS=1 /quiet
