#DSC setup script for Azure DSC
Start-Process chrome.exe 'https://docs.microsoft.com/en-us/azure/automation/automation-dsc-onboarding#using-a-dsc-configuration'
#Get Azure Automation Keys & URL
'docs.microsoft.com/en-us/azure/automation/automation-dsc-onboarding#secure-registration'
#DSC Module 'PSDesiredStateConfiguration' 
Start-Process chrome.exe 'https://docs.microsoft.com/en-us/powershell/module/psdesiredstateconfiguration/?view=powershell-5.1'
#DSC Built in resources
Start-Process chrome.exe 'docs.microsoft.com/en-us/powershell/scripting/dsc/resources/resources?view=powershell-6#built-in-resources'
#DSC File resource
Start-Process chrome.exe 'https://docs.microsoft.com/en-us/powershell/scripting/dsc/reference/resources/windows/fileresource?view=powershell-5.1'


#Command to set system DSC local config manager to register to MOF file
Set-DscLocalConfigurationManager -Path C:\Scripts\DscMetaConfigs -ComputerName $env:COMPUTERNAME



<#

Order of setting up DSC

1. Generate the DSC config file with the actions your would like it to do.
2. Upload the DSC config file to Azure or DSC server.
3. Compile the uploaded DSC config file within Azure.
4. Create MOF file for the system being adding to DSC management.
5. Run Set-DscLocalConfigurationManager command pointing to MOF file.
6. View results of DSC management.
7. Change DSC config if needed within Azure.


#>