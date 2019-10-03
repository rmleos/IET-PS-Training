#Get list of all hotfixes
Get-Hotfix

#Check for hotfix on remote system
Get-HotFix -ComputerName scwsus -id KB4012213
#Check computer for multiple updates
Get-HotFix -ComputerName scwsus -id 'KB4012213', 'KB4012216', 'KB4015550', 'KB4019215'
#Result of system that does not have the update
Get-HotFix -ComputerName sclib01 -id KB4012213
#Result of system that does not have the update, silentce error output and save it to variable
Get-HotFix -ComputerName sclib01 -id KB4012213 -ErrorAction SilentlyContinue -ErrorVariable Problem
# View error details from variable
$Problem

#null Problem variable
$Problem = $null

#Check multiple computers for multiple updates and report those that have missing updates
Invoke-Command -ComputerName scwsus, sclib01 {
    $Patches = 'KB4012598', #Windows XP, Vista, Server 2003, 2008
               'KB4018466', #Server 2008
               'KB4012212', 'KB4012215', 'KB4015549', 'KB4019264', #Windows 7, Server 2008 R2
               'KB4012214', 'KB4012217', 'KB4015551', 'KB4019216', #Server 2012
               'KB4012213', 'KB4012216', 'KB4015550', 'KB4019215', #Windows 8.1, Server 2012 R2
               'KB4012606', 'KB4015221', 'KB4016637', 'KB4019474', #Windows 10
               'KB4013198', 'KB4015219', 'KB4016636', 'KB4019473', 'KB4016871', #Windows 10 1511
               'KB4013429', 'KB4015217', 'KB4015438', 'KB4016635', 'KB4019472' #Windows 10 1607, Server 2016
    Get-HotFix -Id $Patches
} -ErrorAction SilentlyContinue -ErrorVariable Problem
foreach ($p in $Problem) {
    if ($p.origininfo.pscomputername) {
        Write-Warning -Message "Patch not found on $($p.origininfo.pscomputername)"
    }
    elseif ($p.targetobject) {
        Write-Warning -Message "Unable to connect to $($p.targetobject)"
    }
}

#Windows Update PowerShell Module (3-rd party module)
Start-Process iexplore.exe 'https://gallery.technet.microsoft.com/scriptcenter/2d191bcd-3308-4edd-9de2-88dff796b0bc'
Start-Process iexplore.exe 'https://www.powershellgallery.com/packages/PSWindowsUpdate/2.1.0.1'
#Install third part module from powershell gallery
Install-Module PSWindowsUpdate -confirm:$false -force
#Import the PSWindowsUpdate module
Import-Module PSWindowsUpdate
#View commands of the module
Get-Command -Module PSWindowsUpdate
#Get the help of the 
Help Get-WUInstall –full


#List all the upates avalable or installed
Get-WindowsUpdate
#Check for KB4012214 
Get-WindowsUpdate -ServiceID KB4012214
#List all the upates avalable to Windows and features, alias for Get-WindowsUpdate -Download
Download-WindowsUpdate
#Install windows updates, alias for Get-WindowsUpdate -Install
Install-WindowsUpdate

#Check for Microsoft monitoring agent
(Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Microsoft Operations Manager\3.0\Agent Management Groups\") 
#Put reg info into variable and check if it matches known value
$mma =(Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Microsoft Operations Manager\3.0\Agent Management Groups\") 
$mma.Name -eq 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft Operations Manager\3.0\Agent Management Groups\uConnectSCOM' 

#Install via command line, extract exe
MMASetup-AMD64.exe /C /t:C:\Deploy
#Run the extract setup.exe with Arguments
setup.exe /qn NOAPM=1 MANAGEMENT_GROUP=uConnectSCOM MANAGEMENT_SERVER_DNS=scom21.ad3.ucdaivs.edu SECURE_PORT=5723 ACTIONS_USE_COMPUTER_ACCOUNT=1 USE_MANUALLY_SPECIFIED_SETTINGS=1 AcceptEndUserLicenseAgreement=1


#Microsoft monitoring agent file name
$FileName = "MMASetup-AMD64.exe"
#UNC path to file
$filesource = '\\sclib01\VMMLibrary\Software'
#Full UNC path to file
$MMAFile = $filesource + "\" + $FileName
#Arguments for installer
$ArgumentList = '/C:"setup.exe /qn NOAPM=1 MANAGEMENT_GROUP=uConnectSCOM MANAGEMENT_SERVER_DNS=scom21.ad3.ucdaivs.edu SECURE_PORT=5723 ACTIONS_USE_COMPUTER_ACCOUNT=1 USE_MANUALLY_SPECIFIED_SETTINGS=1 AcceptEndUserLicenseAgreement=1"'
#Local server file location to copy Microsoft monitoring agent to
$localfilesource = 'C:\Deploy\MMASetup-AMD64.exe'
#Command to copy file from UNC to local path
Copy-Item -Path $MMAFile -Destination C:\Deploy
#command to run proccess for EXE and Arguments for installer
Start-Process $localfilesource -ArgumentList $ArgumentList




#Install Microsoft monitoring agent on remote computers !!!Will not work because of double hop of credentials 
Invoke-Command -ComputerName scwsus, sclib01 {
#Microsoft monitoring agent file name
$FileName = "MMASetup-AMD64.exe"
#UNC path to file
$filesource = '\\sclib01\VMMLibrary\Software'
#Full UNC path to file
$MMAFile = $filesource + "\" + $FileName
#Arguments for installer
$ArgumentList = '/C:"setup.exe /qn NOAPM=1 MANAGEMENT_GROUP=uConnectSCOM MANAGEMENT_SERVER_DNS=scom21.ad3.ucdaivs.edu SECURE_PORT=5723 ACTIONS_USE_COMPUTER_ACCOUNT=1 USE_MANUALLY_SPECIFIED_SETTINGS=1 AcceptEndUserLicenseAgreement=1"'
#Local server file location to copy Microsoft monitoring agent to
$localfilesource = 'C:\Deploy\MMASetup-AMD64.exe'
#Command to copy file from UNC to local path
Copy-Item -Path $MMAFile -Destination C:\Deploy
#command to run proccess for EXE and Arguments for installer
Start-Process $localfilesource -ArgumentList $ArgumentList
}



#Copy agent file from UNC path to each server 
#array of servers
$servers = 'scwsus', 'sclib01'
#For each server in server array copy the agent to it's C:\Deploy directory
foreach ($server in $servers){
#Microsoft monitoring agent file name
$FileName = "MMASetup-AMD64.exe"
#UNC path to file
$filesource = '\\sclib01\VMMLibrary\Software'
#Full UNC path to file
$MMAFile = $filesource + "\" + $FileName
#Command to copy file from UNC to local path
Copy-Item -Path $MMAFile -Destination \\$server\C$\Deploy
}


#Install Microsoft monitoring agent on remote computers
Invoke-Command -ComputerName scwsus, sclib01 {
    #Local server file location to copy Microsoft monitoring agent to
    $localfilesource = 'C:\Deploy\MMASetup-AMD64.exe'
    #Arguments for installer
    $ArgumentList = '/C:"setup.exe /qn NOAPM=1 MANAGEMENT_GROUP=uConnectSCOM MANAGEMENT_SERVER_DNS=scom21.ad3.ucdaivs.edu SECURE_PORT=5723 ACTIONS_USE_COMPUTER_ACCOUNT=1 USE_MANUALLY_SPECIFIED_SETTINGS=1 AcceptEndUserLicenseAgreement=1"'
    #Command to copy file from UNC to local path
    Copy-Item -Path $MMAFile -Destination C:\Deploy
    #command to run proccess for EXE and Arguments for installer
    Start-Process $localfilesource -ArgumentList $ArgumentList
    }
    



#Check for Microsoft monitoring agent on remote computers and install if missing
Invoke-Command -ComputerName scwsus, sclib01 {
    $mma =(Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Microsoft Operations Manager\3.0\Agent Management Groups\"  -ErrorAction SilentlyContinue ) 
    if ($mma.Name -ne 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft Operations Manager\3.0\Agent Management Groups\uConnectSCOM')
    {
        Write-Host 'Microsoft monitoring agent is not installed on'$env:COMPUTERNAME -ForegroundColor Yellow
        #Arguments for installer
        $ArgumentList = '/C:"setup.exe /qn NOAPM=1 MANAGEMENT_GROUP=uConnectSCOM MANAGEMENT_SERVER_DNS=scom21.ad3.ucdaivs.edu SECURE_PORT=5723 ACTIONS_USE_COMPUTER_ACCOUNT=1 USE_MANUALLY_SPECIFIED_SETTINGS=1 AcceptEndUserLicenseAgreement=1"'
        #Local server file location to copy Microsoft monitoring agent to
        $localfilesource = 'C:\Deploy\MMASetup-AMD64.exe'
        #command to run proccess for EXE and Arguments for installer
        Start-Process $localfilesource -ArgumentList $ArgumentList
        Start-Sleep 10
        $mma =(Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Microsoft Operations Manager\3.0\Agent Management Groups\")
        if ($mma.Name -eq 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft Operations Manager\3.0\Agent Management Groups\uConnectSCOM')
        {
            Write-Host 'Microsoft monitoring agent is already installed on'$env:COMPUTERNAME -ForegroundColor Green
        }
        else
        {
        Write-Host 'Microsoft monitoring agent failed on'$env:COMPUTERNAME -ForegroundColor Yellow
        }
    }

    else
    {
        Write-Host 'Microsoft monitoring agent is already installed on'$env:COMPUTERNAME -ForegroundColor Green
    }
}
