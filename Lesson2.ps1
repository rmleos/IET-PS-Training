#Informaion about the topic today
#Powershell ISE link
Start-Process iexplore.exe 'https://docs.microsoft.com/en-us/powershell/scripting/components/ise/exploring-the-windows-powershell-ise?view=powershell-5.1'
#Enable PS Remoting, enabled on 2012 by deefault
Start-Process iexplore.exe 'https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/enable-psremoting?view=powershell-5.1'
#Enable PS Remoting by GPO
Start-Process iexplore.exe 'https://www.techrepublic.com/article/how-to-enable-powershell-remoting-via-group-policy/'
#Window scripting blog
Start-Process iexplore.exe 'https://devblogs.microsoft.com/scripting/'



#Modules are scripts that contain functions to get data from specific resrouces
#Import Active Directory module
Import-Module ActiveDirectory

#Lookup user in AD
get-aduseer -Identity rick-srv
#Build user UPN
$usernUPN = $env:USERNAME+'@'+$env:USERDNSDOMAIN
#lookup user in AD using variable
get-aduser -Identity $usernUPN

#Lookup computer in AD 
get-adcomputer -Identity putil4
#Lookup computer in AD using Enviorment varable
Get-ADComputer -Identity $env:COMPUTERNAME

#Create an object
$myobject = New-Object -TypeName PSObject
#Add object data to your object
Add-Member -InputObject $myobject -MemberType NoteProperty -Name MYPCOperatingSystem -Value $os.Name
Add-Member -InputObject $myobject -MemberType NoteProperty -Name MyPCVersion -Value $os.Version
Add-Member -InputObject $myobject -MemberType NoteProperty -Name MYPCInstallDate -Value $os.InstallDate
Add-Member -InputObject $myobject -MemberType NoteProperty -Name MYPCName -Value $os.CSName
Add-Member -InputObject $myobject -MemberType NoteProperty -Name MYPCUser -Value $env:USERNAME

#Lookup computer in AD using property in custom object
Get-ADComputer -Identity $myobject.MYPCName

#Troubleshooting powershell errors
#Lookup computer in AD will bad object
Get-ADComputer -Identity $myobject.MYPChostname

#Lookup computer in AD fails, not found in domain
Get-ADComputer -Identity DCCS-RDB

Get-ADComputer -Identity DCCS-RDB -Server


# Change fonts (Can be done in Tools->Options)    
$psISE.Options.FontName = 'Old English Text MT'
$psISE.Options.FontName = 'Times New Roman'
$psISE.Options.FontName ='Lucida Console'
$psISE.Options.FontSize = 12
$psISE.Options.FontSize = 9 

# script pane colors        (Can be done in Tools->Options)     
$psISE.Options.ScriptPaneBackgroundColor = 'Gray'             
$psISE.Options.ScriptPaneForegroundColor = 'White' 

# Console pane colors            (Can be done in Tools->Options)    
$psISE.Options.ConsolePaneBackgroundColor = 'Black'            
$psISE.Options.ConsolePaneTextBackgroundColor = 'Gray'             
$psISE.Options.ConsolePaneForegroundColor = 'White' 
            
# UCD Console pane colors            
$psISE.Options.ConsolePaneBackgroundColor = '#DAAA00'            
$psISE.Options.ConsolePaneTextBackgroundColor = '#002855'             
$psISE.Options.ConsolePaneForegroundColor = '#DAAA00' 



#Reset Colors
# script pane colors         
$psISE.Options.ScriptPaneBackgroundColor = '#F5F5F5'          
$psISE.Options.ScriptPaneForegroundColor = 'Black' 
# Console pane colors            
$psISE.Options.ConsolePaneBackgroundColor = '#012456'             
$psISE.Options.ConsolePaneTextBackgroundColor = '#012456'             
$psISE.Options.ConsolePaneForegroundColor = '#F5F5F5' 


#Powershell profiles, are script files that load 
#All Users, All Hosts !!CAUTION!!!!
$PROFILE.AllUsersAllHosts
#All Users, Current Host !!CAUTION!!!!
$PROFILE.AllUsersCurrentHost
#Current User, All Hosts
$PROFILE.CurrentUserAllHosts
#Current user, Current Host
$PROFILE.CurrentUserCurrentHost
$PROFILE

#Open your profile 
Invoke-Item $profile
#open the profile location
invoke-item C:\Users\Rick\Documents\

#Create Profile sccript file
if (!(Test-Path -Path $PROFILE ))
{ New-Item -Type File -Path $PROFILE -Force }

#Items I want in my profile
$env:COMPUTERNAME
$env:USERNAME
Get-NetIPAddress | select IPAddress
Write-Host 'If you work to hard Tom will just give you more work!' -BackgroundColor Red -ForegroundColor Yellow

#Use Powershell to add text to file
Add-Content $PROFILE {
    Write-Host 'If you work to hard Tom will just give you more work!' -BackgroundColor Red -ForegroundColor Yellow
    $env:COMPUTERNAME
    $env:USERNAME
    Get-NetIPAddress | select IPAddress
}

#PowerShell remoting
Enter-PSSession -ComputerName SCWSUS
Get-Service
Get-Service WsusService
stop-Service WsusService
start-Service WsusService
#Exit remote poswershell session
Exit

#Invoke Remote command
Invoke-Command -ComputerName scwsus -ScriptBlock {get-service WsusService}


$ADFSservers = 'adfs10', 'adfs11', 'adfs12', 'adfs13';
$result = @()
foreach ($server in $ADFSservers)
{
    #Invokes remove command to get the service state
    $result += Invoke-Command -ComputerName $server -ScriptBlock { Get-Service adfssrv}
}


function Get-ADFSService
{
    #Function gets the ADFS Windows Service (adfssrv) running state
    #ADFS Servers
    $ADFSservers = 'adfs10', 'adfs11', 'adfs12', 'adfs13';
    $result = @()
    foreach ($server in $ADFSservers)
    {
        #Invokes remove command to get the service state
        $result += Invoke-Command -ComputerName $server -ScriptBlock { Get-Service adfssrv}
    }
    $result
}