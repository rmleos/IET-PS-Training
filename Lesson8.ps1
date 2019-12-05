
#Lookup locaL administrators
Get-LocalGroupMember -Group Administrators 

#Local group to look up
$Lgroup = "Administrators"
#Lookup local group
$Ladmins = Get-LocalGroupMember -Group $Lgroup

#View just the 4th object in $Ladmins
$Ladmins[4].Name

#Group lookup doesnt work with domain prefix
Get-ADUser -Identity 'domain\Domain Admins'
#Group lookup doesnt work with computer name prefix
Get-LocalUser -Name computer\Administrator
#Example of failed lookup
Get-LocalUser $Ladmins[4].Name

#Proper lookup format for domain group
Get-ADGroup -Identity 'Domain Admins' -Server domain
#Proper lookup format for local user
Get-LocalUser -Name Administrator

#Use PowerShell to trim staart of string if contains computer name and \
$Ladmins[3].Name.TrimStart( ($env:COMPUTERNAME)+'\' )

#Use PowerShell to Split to seperate string by character  
$Ladmins[3].Name.Split("\")
$Ladmins[3].Name.Split("\")[0]
$Ladmins[3].Name.Split("\")[1]
#Get local user from local group data 
Get-LocalUser $Ladmins[3].Name.Split("\")[1]


#Lookup AD group
Get-ADGroup -Identity 'Domain Admins' -Server domain
#Lookup AD group memebers
Get-ADGroupMember -Identity 'Domain Admins' -Server domain
#Look up AD user and all its properties
Get-ADUser -Identity rick-da -Server AD3 -Properties * 
#Look up AD user and select certain properties
Get-ADUser -Identity rick-da -Server AD3 -Properties * | select Name,Enabled,SID,ObjectClass,@{Name="lastLogon";Expression={[datetime]::FromFileTime($_.'lastLogon')}},DistinguishedName


$domainaccounts = @()
$localaccounts = @()
 
#Loop threw all accounts in local admins group
foreach ($account in $Ladmins)
{
    #If the account is local and User type
    if ($account.PrincipalSource -eq 'Local' -and $account.ObjectClass -eq 'User' )
    {
          $localaccounts += Get-LocalUser  $account.Name.Split("\")[1] | select Name,Enabled,SID,PrincipalSource,ObjectClass,LastLogon
    }
    #If the account is Active Directory and User type
    if ($account.PrincipalSource -eq 'ActiveDirectory' -and $account.ObjectClass -eq 'User')
    {
        $domainaccounts += Get-ADUser -Identity $account.Name.Split("\")[1] -Server $account.Name.Split("\")[0] -Properties * | select Name,Enabled,SID,ObjectClass,@{Name="lastLogon";Expression={[datetime]::FromFileTime($_.'lastLogon')}},DistinguishedName
    }
    #If the account is Active Directory and Group type
    if ($account.PrincipalSource -eq 'ActiveDirectory' -and $account.ObjectClass -eq 'Group')
    {
        #Array to store AD group memebers
        $domaingroup = @()
        $domaingroup = $null
        #Looks up AD group members
        $domaingroup += Get-ADGroupMember -Identity $account.Name.Split("\")[1] -Server $account.Name.Split("\")[0]
        #For each user in AD group
        foreach ($user in $domaingroup)
        {
            #If member is User type
            if ($user.objectClass -eq 'user')
            {
               $domainaccounts += Get-ADUser -Identity $user -Properties * | select Name,Enabled,SID,ObjectClass,@{Name="lastLogon";Expression={[datetime]::FromFileTime($_.'lastLogon')}},DistinguishedName
            }
            #If not User type
            else
            {
                $domainaccounts += Get-ADGroup -Identity $user -Properties * | select Name,Enabled,SID,ObjectClass,@{Name="lastLogon";Expression={[datetime]::FromFileTime($_.'lastLogon')}},DistinguishedName
            }
        }

    }

}

#Join the local account array with the domain account arry
$allaccounts = ($localaccounts | Format-List)+$domainaccounts

#Output the results
Write-Host "Local Administrator Group contains:" -ForegroundColor Cyan
$Ladmins

Write-Host "The AD groups contain AD users:" -ForegroundColor Cyan
$allaccounts
