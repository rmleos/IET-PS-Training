#Comment starts with # before text

<#
If you want
multiple line of
comments start with <#
then end with #>
#>

#working with commands
#Powershell command are always in a verb-noun format
#Verb examples
set
new
add 
remove
#noun examples
aduser
adgroup
WmiObject
Command

#Find commands
Get-Command -Verb Set
Get-Command -Noun aduser
Get-Command -Module ActiveDirectory
get-command get-aduser

#Powershell help
get-help get-aduser




#Checck what account is used to run the powershell session
whoami

#varable
$myvarable = 'Hello'
$myvarable = 'annyawhnghasehyo'

$myvarable2 = 'annyawhnghasehyo'

#Built in variable Null
$null

#Using null variable to null a variable
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




#View group in AD
Get-ADGroup -Identity IET-US-demo -Server ou.ad3.ucdavis.edu

#Create AD group
New-ADGroup -Name IET-US-PS-Lession1 -Description 'Created for IET PS Training' -GroupScope Universal -GroupCategory Security -Path 'OU=uConnect-OU-Groups,OU=uConnect,OU=DEPARTMENTS,DC=ou,DC=ad3,DC=ucdavis,DC=edu' -Server ou.ad3.ucdavis.edu
#veiw AD  group
Get-ADGroup -Identity IET-US-PS-Lession1 -Server ou.ad3.ucdavis.edu
#View members of the AD Group
Get-ADGroupMember -Identity IET-US-PS-Lession1 -Server ou.ad3.ucdavis.edu
#Add users to AD group
Add-ADGroupMember -Identity IET-US-PS-Lession1 -Members rmleos,rick-srv -Server ou.ad3.ucdavis.edu
#Add user to AD group in diffrent domains
$AD3user = Get-ADUser -Identity rmleos -Server ad3.ucdavis.edu
$OUgroup = Get-ADGroup -Identity IET-US-PS-Lession1 -Server ou.ad3.ucdavis.edu
Add-ADGroupMember -Identity $OUgroup -Members $AD3user -Server ou.ad3.ucdavis.edu


#Foreach loop takes a collection of object or variables and will process each single object to preform an action 
foreach ($item in $collection) {
    
}

#list of users
$userList = 'rmleos', 'rick-srv'
#Foreach loop to get users AD info
foreach ($user in $userList) {
    Get-ADUser -Identity $user
}


#Foreach loop to add users to AD group using pre-declared variables 
$userList = 'rmleos', 'rick-srv'
$ad3domain = 'ad3.ucdavis.edu'
$oudomain = 'ou.ad3.ucdavis.edu'
$OUadgroup = 'IET-US-PS-Lession1'

foreach ($user in $userList) {
    $aduser = Get-ADUser -Identity $user -Server $ad3domain
    $adgroup = Get-ADGroup -Identity $OUadgroup -Server $oudomain
    Add-ADGroupMember -Identity $OUadgroup -Members $aduser -Server $oudomain
}