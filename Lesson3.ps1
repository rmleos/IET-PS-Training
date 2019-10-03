#Windows Update PowerShell Module (3-rd party module)
Start-Process iexplore.exe 'https://gallery.technet.microsoft.com/scriptcenter/2d191bcd-3308-4edd-9de2-88dff796b0bc'
Import-Module 

#Get list of all hotfixes
Get-Hotfix

#Check for hotfix on remote system
Get-HotFix -ComputerName scwsus -id KB4012213

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