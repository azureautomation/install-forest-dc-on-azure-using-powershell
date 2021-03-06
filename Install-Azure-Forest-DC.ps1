<#
Install-Azure-Forest-DC.ps1

Install Forest DC on Azure using Powershell (domain and forestmode 2012R2)
#>

# Change the following 3 Variables
$domainname = "company.cloud"
$netbiosname = "company"
$password = "Password123!" | ConvertTo-SecureString -AsPlainText -Force

# Check reg key
$regkey = test-path hklm:\software\FTCAD
if ($regkey -eq $true) {exit}

# Start deployment steps
else 
{

# Turn Off Firewall
netsh advfirewall set allprofiles state off

# Set Winrm for remote PS
Set-Item wsman:\localhost\client\trustedhosts * -Force

# Install ADDS features
Add-WindowsFeature RSAT-AD-Tools
Add-WindowsFeature -Name "ad-domain-services" -IncludeAllSubFeature -IncludeManagementTools
Add-WindowsFeature -Name "dns" -IncludeAllSubFeature -IncludeManagementTools 
Add-WindowsFeature -Name "gpmc" -IncludeAllSubFeature -IncludeManagementTools
REG ADD HKLM\Software\FTCAD /v Data /t Reg_SZ /d "Installed"
# AD Forest Deployment
Import-Module ADDSDeployment
Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "Win2012R2" `
-DomainName $domainname `
-DomainNetbiosName $netbiosname `
-ForestMode "Win2012R2" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$false `
-SafeModeAdministratorPassword $password `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true
}