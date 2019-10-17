#Link new-pssession
Start-Process iexplore.exe 'https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/new-pssession?view=powershell-5.1'
#Link IF statment
Start-Process iexplore.exe  'https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_if?view=powershell-5.1'
#Link ForEach statment
Start-Process iexplore.exe 'https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_foreach?view=powershell-5.1'
#Link copy-item
Start-Process iexplore.exe 'https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/copy-item?view=powershell-5.1'



#PSSession types
#Turns your powershell sessions into session on remote system
Enter-PSSession
#Sends command to remote system via powershell remoting
Invoke-Command
#Create persistent connection to remote system
New-PSSession

#Create persistent session to remote system
New-PSSession -ComputerName adconnect



#List of servers via csv with  multiple data points
$list = import-csv -Path C:\Users\rick-srv\Documents\serverlist.csv
#List of servers via txt file
$computerlist = Get-Content -Path C:\Users\rick-srv\Documents\serverlist2.txt


#For each statement
#Use Snippets for easy creation of a statment   ( CTRL + J )
foreach ($item in $collection)
{
    
}

#IF statement
#Use Snippets for easy creation of a statment   ( CTRL + J )
if ($x -gt $y)
{
    
}


#Get files in directory
Get-ChildItem -Path C:\Deploy
#Get names of files in directory
(Get-ChildItem -Path C:\Deploy).Name 


#Use IF statement to check if file exists and write message that it is present
if ((Get-ChildItem -Path C:\Deploy).Name -contains 'LAPS.x64.msi')
{
    Write-Host "LAPS msi is present." -ForegroundColor Cyan
}



#Use IF-Else statement to check if file exists and write message that it is present. If does not exists write message that it is not present.
if ((Get-ChildItem -Path C:\Deploy).Name -contains 'setup.exe')
{
   Write-Host "Setup exe is present." -ForegroundColor Cyan 
}
else
{
   Write-Host "Setup exe is not present." -ForegroundColor Yellow
}



#Create a PSSessions to the list of systems
foreach ($system in $list)
{
    New-PSSession -ComputerName $system.ServerName -Name $system.ServerName
}

#View the current PSSessions
Get-PSSession


#Save the PSSession for SCWSUS into an Array
$session = Get-PSSession -Name scwsus
#Use the array containing the PSSession to run command therw the session
Invoke-Command -Session $session  -ScriptBlock {get-service WsusService}


#Save all PSSessions into an Array
$sessions = Get-PSSession


#Remove all PSSessions from powershell session
Get-PSSession | Remove-PSSession


#Get list of all variables
Get-Variable
#Create new Variable
New-Variable -Name test  -Value '1234'
#Get the created Variable
Get-Variable -Name test
#Get name of a Variable
(Get-Variable -Name test).Name
#Get vaule of a Variable
(Get-Variable -Name test).Value
#Get vaule of a Variable
$test


#Create Variable for each server in a list and PSSession to it. Then save the PSSession  to the Variable
foreach ($system in $list)
{
    New-Variable -Name $system.ServerName
    $(Get-Variable -Name "$($system.ServerName)").Value = New-PSSession -ComputerName $system.ServerName -Name $system.ServerName

}

#Copy file from remote system to local system via Pssession 
Copy-Item "C:\Deploy\LAPS.x64.msi" -FromSession $sclib01 -Destination "C:\temp\"

#Copy file from local system to remote system via Pssession 
Copy-Item "C:\Deploy\LAPS.x64.msi" -ToSession $scwsus -Destination "C:\Deploy\"

#Copy file from File Share to remote system via Pssession 
Copy-Item "\\sclib01\VMMLibrary\Software\LAPS.x64.msi" -ToSession $scwsus -Destination "C:\Deploy\"

#Why not use both FromSession and ToSession together? They mutually exclusive parameters 
Copy-Item "C:\Deploy\LAPS.x64.msi" -FromSession $sclib01 -ToSession $scwsus -Destination "C:\Deploy\"
