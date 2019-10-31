#List of servers via csv with  multiple data points
$list = import-csv -Path C:\Users\rick-srv\Documents\serverlist.csv
#removes existing pssessions
Get-PSSession | Remove-PSSession
#Create Variable for each server in a list and PSSession to it. Then save the PSSession  to the Variable
foreach ($system in $list)
{
    $session = New-PSSession -ComputerName $system.ServerName -Name $system.ServerName
    $localLapsfile = @()
    $localLapsDLL = @()
    #Invoke command get info about LAPS install and MSI file
    $localLapsfile = invoke-Command -Session $session -ScriptBlock {
        #Checks for the LAPS install file
        if ((Get-ChildItem -Path C:\Deploy -ErrorAction SilentlyContinue).Name -contains 'LAPS.x64.msi')
        {
            #Write-Host "LAPS msi is present on $server." -ForegroundColor Cyan
            $true
        }
        else
        {
            #Write-Host "LAPS msi is not present on $server." -ForegroundColor Yellow
         $false
        }
    }
    $localLapsDLL = invoke-Command -Session $session -ScriptBlock {
        #Check in the LAPS client is insall to default path
        if ((Get-ChildItem -Path 'C:\Program Files\LAPS\CSE' -ErrorAction SilentlyContinue).Name -contains 'AdmPwd.dll')
        {
            #Write-Host "LAPS DLL is present on $server." -ForegroundColor Cyan
             $true
        }
        else
        {
            #Write-Host "LAPS DLL is not present on $server." -ForegroundColor Yellow
         $false
        }
    }

    
    #Staments figures out if LAPS is installed and if file is on system
    #If LAPS is not installed and LAPS msi is not in c:\Deploy, it will copy file and installing LAPS
    if ($localLapsDLL -eq $false -and $localLapsfile -eq $false) {
        Copy-Item "C:\Deploy\LAPS.x64.msi" -ToSession $session -Destination "C:\Deploy\"
        $localLapsfile = invoke-Command -Session $session -ScriptBlock {
            #Checks for the LAPS install file
            if ((Get-ChildItem -Path C:\Deploy -ErrorAction SilentlyContinue).Name -contains 'LAPS.x64.msi')
            {
                #Write-Host "LAPS msi is present on $server." -ForegroundColor Cyan
                $true
            }
            else
            {
                #Write-Host "LAPS msi is not present on $server." -ForegroundColor Yellow
             $false
            }
        }
        if ($localLapsDLL -eq $false -and $localLapsfile -eq $true) {
            
            invoke-Command -Session $session -ScriptBlock {
                if ((Get-ChildItem -Path C:\Deploy -ErrorAction SilentlyContinue).Name -contains 'LAPS.x64.msi')
                {
                    Write-Host "LAPS msi file is present on $env:COMPUTERNAME starting install." -ForegroundColor Cyan
                    #Local LAPS agent
                    $localfilesource = 'C:\Deploy\LAPS.x64.msi'
                    #Arguments for installer
                    $ArgumentList = '/quiet'
                    #command to run proccess for MSI and Arguments for installer "msiexec /i <file location>\LAPS.x64.msi /quiet"
                    Start-Process $localfilesource -ArgumentList $ArgumentList
                }
            }
            Start-Sleep -Seconds 10
            #Recheck of LAPS DLL
            invoke-Command -Session $session -ScriptBlock {
                #Check in the LAPS client is insall to default path
                if ((Get-ChildItem -Path 'C:\Program Files\LAPS\CSE' -ErrorAction SilentlyContinue).Name -contains 'AdmPwd.dll')
                {
                    Write-Host "LAPS DLL is present on $env:COMPUTERNAME ." -ForegroundColor Cyan
                }
                else {
                    Write-Host "LAPS DLL is non present on $env:COMPUTERNAME ." -ForegroundColor Yellow             
                }
            }
        }
    }


    #If LAPS is not installed and LAPS msi is in c:\Deploy, it will start installing LAPS
    else {
        if ($localLapsDLL -eq $false -and $localLapsfile -eq $true ) {
        invoke-Command -Session $session -ScriptBlock {
            Write-Host "LAPS msi file is present on $env:COMPUTERNAME starting install." -ForegroundColor Cyan
            #Local LAPS agent
            $localfilesource = 'C:\Deploy\LAPS.x64.msi'
            #Arguments for installer
            $ArgumentList = '/quiet'
            #command to run proccess for MSI and Arguments for installer "msiexec /i <file location>\LAPS.x64.msi /quiet"
            Start-Process $localfilesource -ArgumentList $ArgumentList
            }
        }
        Start-Sleep -Seconds 10
        #Recheck for LAPS DLL
        invoke-Command -Session $session -ScriptBlock {
            #Check in the LAPS client is insall to default path
            if ((Get-ChildItem -Path 'C:\Program Files\LAPS\CSE' -ErrorAction SilentlyContinue).Name -contains 'AdmPwd.dll')
            {
                Write-Host "LAPS DLL is present on $env:COMPUTERNAME ." -ForegroundColor Cyan
            }
            else {
                Write-Host "LAPS DLL is non present on $env:COMPUTERNAME ." -ForegroundColor Yellow             
            } 
        }
    }
}