#Connects to C drive of each computer in a list. Then sort the last writen time of each user profile and selects the most recent. Then exports results or failed to connect result to CSV

$computers = Get-Content -Path C:\temp\Downloads\PCList.csv
$RptDate = Get-Date -Format "yyyy-MM-dd"
foreach ($computer in $computers)
{
$result = Get-ChildItem "\\$computer\c$\Users" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending -ErrorAction SilentlyContinue

    $item = [PSCustomObject]@{  
    UserName = ''
    LastWriteTime = ''
    computer = ''
    }

if (!$result)
{
   
    $item.UserName = "" 
    $item.LastWriteTime = "Did not connect"
    $item.computer = $computer
}
else
{

    $newresutl = $result | Select-Object Name, LastWriteTime -first 1
    $item.UserName = $newresutl.Name 
    $item.LastWriteTime = $newresutl.LastWriteTime
    $item.computer = $computer

}

$item | Export-Csv -path C:\temp\BitLockerProtectionOffPCs$RptDate.csv -NoTypeInformation -Append -Force


}