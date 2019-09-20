#Powershell ISE link
https://docs.microsoft.com/en-us/powershell/scripting/components/ise/exploring-the-windows-powershell-ise?view=powershell-5.1



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
    Add-ADGroupMember -Identity $adgroup -Members $aduser -Server $oudomain
}