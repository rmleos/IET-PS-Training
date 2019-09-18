#Comment starts with # before text

<#
If you want
multiple line of
comments start with <#
then end with #>
#>


#Checck what account is used to run the powershell session
whoami

#varable
$myvarable = 'Hello'
$myvarable = 'annyawhnghasehyo'

$myvarable2 = 'annyawhnghasehyo'

#Built in variable Null
$null

#Using null variable to null a varable
$myvarable = $null

#Enviorment variable, gets computer name
$env:COMPUTERNAME
#Gets user name
$env:USERNAME
#Gets users domain
$env:USERDNSDOMAIN

$computername = $env:COMPUTERNAME
$username = $env:USERNAME
#Create UPN from user name and users domain
$env:USERNAME+'@'+$env:USERDNSDOMAIN
#Save UPN to variable
$usernUPN = $env:USERNAME+'@'+$env:USERDNSDOMAIN




#Array a collection of varables or objects
$myarry = 'Hello', 'annyawhnghasehyo'

#View first item in as array
$myarry[0]
#View second item in an array
$myarry[1]

#Create an empaty Arryay
$myarry2 = @()
#View array
$myarry2

#Add variables to array
$myarry2 += $myvarable
$myarry2 += $myvarable2




#Object is a collection of known attributes/properties to consume
Get-WmiObject Win32_OperatingSystem

#Add object to Array
$os = Get-WmiObject Win32_OperatingSystem
#view Array conatining object
$os

#View a property of an object
$os.BuildNumber
$os.Version
#View all properties of an object
$os.Properties
#View all properties of an object by Name
$os.Properties.Name

#View Install Date hidden property
$os.InstallDate  

#Create an object
$myobject = New-Object -TypeName PSObject
#Add object data to your object
Add-Member -InputObject $myobject -MemberType NoteProperty -Name MYPCOperatingSystem -Value $os.Name
Add-Member -InputObject $myobject -MemberType NoteProperty -Name MyPCVersion -Value $os.Version
Add-Member -InputObject $myobject -MemberType NoteProperty -Name MYPCInstallDate -Value $os.InstallDate
Add-Member -InputObject $myobject -MemberType NoteProperty -Name MYPCName -Value $os.CSName
Add-Member -InputObject $myobject -MemberType NoteProperty -Name MYPCUser -Value $env:USERNAME

#View created object
$myobject
#View variables in object
$myobject.MYPCOperatingSystem
$myobject.MyPCVersion
$myobject.MYPCInstallDate
$myobject.MYPCName
$myobject.MYPCUser




#Modules are scripts that contain functions to get data from specific resrouces
#Import Active Directory module
Import-Module ActiveDirectory

#Lookup user in AD
get-aduseer -Identity rick-srv
#lookup user in AD using variable
get-aduser -Identity $usernUPN

#Lookup computer in AD 
get-adcomputer -Identity putil4
#Lookup computer in AD using Enviorment varable
Get-ADComputer -Identity $env:COMPUTERNAME 
#Lookup computer in AD using property in custom object
Get-ADComputer -Identity $myobject.MYPCName




#Troubleshooting powershell errors
#Lookup computer in AD will bad object
Get-ADComputer -Identity $myobject.MYPChostname

#Lookup computer in AD fails, not found in domain
Get-ADComputer -Identity DCCS-RDB

Get-ADComputer -Identity DCCS-RDB -Server