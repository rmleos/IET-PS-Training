#Get-adcomputer command
Start-Process chrome.exe 'https://docs.microsoft.com/en-us/powershell/module/addsadministration/get-adcomputer?view=win10-ps'
#Get-aduser command
Start-Process chrome.exe 'https://docs.microsoft.com/en-us/powershell/module/addsadministration/get-aduser?view=win10-ps'
#Get-adobject command
Start-Process chrome.exe 'https://docs.microsoft.com/en-us/powershell/module/addsadministration/get-adobject?view=win10-ps'


#Get date in month day year format
$rptDate = Get-Date -Format MMddyyyy
#Get date default format
$rptDate2 = Get-Date

$OUdomain = 'ou.ad3.ucdavis.edu'
$SearchScope = 'OU=IET-New,OU=DEPARTMENTS,DC=ou,DC=ad3,DC=ucdavis,DC=edu'


#Searc AD for specific computer
Get-ADComputer -Identity "ietprint" -Properties * -Server $OUdomain

#Search AD for specific group
Get-ADGroup -Identity 'IET-CR-CAD' -Properties * -Server $OUdomain

#Search AD by OU container for all computers
Get-ADComputer -Filter * -Properties * -Server $OUdomain -SearchBase $SearchScope

#Search AD by OU container for all computers in the root of the container
Get-ADComputer -Filter * -Properties * -Server $OUdomain -SearchBase $SearchScope -SearchScope Base 

#Gets all Windows 7 computers by OU container
Get-ADComputer -Filter {(OperatingSystem -Like "Windows 7*")} -Properties * -Server $OUdomain -SearchBase $SearchScope

#Gets all Windows Server 2008 computers by OU container
Get-ADComputer -Filter {(OperatingSystem -Like "Windows Server 2008*")} -Properties * -Server $OUdomain -SearchBase $SearchScope

#Gets all Windows Server 2008 and Windows 7 computers by OU container
Get-ADComputer -Filter {(OperatingSystem -Like "Windows Server 2008*") -or (OperatingSystem -Like "Windows 7*")} -Properties * -Server $OUdomain -SearchBase $SearchScope

#Get AD object by short name fails
Get-ADObject -Identity "ietprint" -Properties * -Server $OUdomain

#Get AD object computer by distinguishedName
Get-ADObject -Identity 'CN=IETPRINT,OU=File and Print,OU=EAIS,OU=Servers,OU=IET-New,OU=DEPARTMENTS,DC=ou,DC=ad3,DC=ucdavis,DC=edu' -Properties * -Server $OUdomain

#Get AD object group by distinguishedName
Get-ADObject -Identity 'CN=IET-CR-CAD,OU=Groups,OU=IET-New,OU=DEPARTMENTS,DC=ou,DC=ad3,DC=ucdavis,DC=edu' -Properties * -Server $OUdomain

#View AD object classes
Get-ADObject -Identity 'CN=IETPRINT,OU=File and Print,OU=EAIS,OU=Servers,OU=IET-New,OU=DEPARTMENTS,DC=ou,DC=ad3,DC=ucdavis,DC=edu' -Properties * -Server $OUdomain | Select Name,ObjectClass
Get-ADObject -Identity 'CN=IET-CR-CAD,OU=Groups,OU=IET-New,OU=DEPARTMENTS,DC=ou,DC=ad3,DC=ucdavis,DC=edu' -Properties * -Server $OUdomain | select Name,ObjectClass




$myadgroups = 
$my 