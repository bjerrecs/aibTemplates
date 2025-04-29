Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

$Packages = '7Zip', 'adobereader', 'jmeter', 'maven', 'dwgtrueview', 'awscli', 'azure-cli', 'microsoftazurestorageexplorer', 'DBeaver', 'fiddler', 'filezilla', 'fslogix', 'git', 'googlechrome', 'javaruntime', 'MiniConda3', 'notepadplusplus', 'Postman', 'pspad', 'putty.install', 'Python3', 'rancher-desktop', 'Rdcman', 'Soapui', 'techsmithsnagit'

ForEach ($PackageName in $Packages)
{
    choco install $PackageName -y
}
