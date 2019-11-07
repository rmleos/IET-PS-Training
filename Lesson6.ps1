#Link about PowerShell Functions
Start-Process iexplore.exe 'https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions?view=powershell-5.1'
#Link Learn to write functions
Start-Process iexplore.exe 'http://powershelltutorial.net/home/Powershell-Language-Functions'
#Link about Hashtables
Start-Process iexplore.exe 'https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_hash_tables?view=powershell-5.1'

#Get logical disk info
Get-WmiObject Win32_LogicalDisk
#Get processor info
Get-WmiObject Win32_Processor
#Get BIOS info
Get-WmiObject Win32_BIOS
#Get info about each Memory module
Get-WmiObject Win32_PhysicalMemory
#Get combined Memory info 
Get-WmiObject Win32_PhysicalMemoryArray
#Get info about the computer
Get-WmiObject -Class Win32_ComputerSystem
#Get OS info
Get-WmiObject Win32_OperatingSystem


Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3"  | Select-Object DeviceID,VolumeName,Size,FreeSpace | Format-Table -AutoSize
Get-WmiObject -Class win32_processor | Select-Object DeviceID,Name,MaxClockSpeed | Format-Table  -AutoSize
Get-WmiObject -Class Win32_BIOS | Select-Object SerialNumber | Format-Table -AutoSize
Get-WmiObject -Class Win32_PhysicalMemory | Select-Object DeviceLocator,Manufacturer,PartNumber,Capacity,Speed | Format-Table -AutoSize
Get-WmiObject -Class Win32_PhysicalMemoryArray | Select-Object MemoryDevices,MaxCapacity | Format-Table  -AutoSize
Get-WmiObject -Class Win32_ComputerSystem | Select-Object Manufacturer,Model | Format-Table  -AutoSize
Get-WmiObject -Class Win32_OperatingSystem | Select-Object Version | Format-Table -AutoSize

#Get the C drive info
$Cdrive = Get-WmiObject -Class Win32_LogicalDisk -Filter "DeviceID='C:'"
#Veiw the size of the C drive
$Cdrive.Size
#Divide the size by Gb
$driv.Size/1Gb
#Change the Divided result from decimal to integer
$driv.Size/1Gb -as [int]


#HashTable
@{ <name> = <value>; [<name> = <value> ] ...}
$hash = @{ Number = 1; Shape = "Square"; Color = "Blue"}
$hash

#Get all hard drives and change the Size & FreeSpace to SizeGB & FreeGB
Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3"  | Select-Object DeviceID,VolumeName,@{Name="SizeGB";Expression={$_.Size/1GB -as [int]}},@{Name="FreeGB";Expression={[math]::Round($_.Freespace/1GB,2)}} | Format-Table -AutoSize

#Blank Function
function FunctionName {
    param (
        OptionalParameters
    )
    
}

#Function to get all hard disks of a computer and  and change the Size & FreeSpace to SizeGB & FreeGB, then show DeviceID VolumeName SizeGB FreeGB
function get-HardDisks {
    param ( $computername = $env:COMPUTERNAME
    )
    Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3" -ComputerName $computername  | Select-Object DeviceID,VolumeName,@{Name="SizeGB";Expression={$_.Size/1GB -as [int]}},@{Name="FreeGB";Expression={[math]::Round($_.Freespace/1GB,2)}}
}

#Function to Name and GHz speed
function get-Processor {
    param ( $computername = $env:COMPUTERNAME
    )
    Get-WmiObject -Class win32_processor -ComputerName $computername | Select-Object Name,@{Name="MaxClockSpeedGHz";Expression={$_.MaxClockSpeed/1000 }}
}

#Function to get BIOS SerialNumber
function get-SerialNumber {
    param ( $computername = $env:COMPUTERNAME
    )
    Get-WmiObject -Class Win32_BIOS -ComputerName $computername | Select-Object SerialNumber
}

#Function to total memory amount by GB
function get-Memory {
    param ( $computername = $env:COMPUTERNAME
    )
    Get-WmiObject -Class Win32_PhysicalMemoryArray -ComputerName $computername| Select-Object @{Name="TotalMemoryGB";Expression={$_.MaxCapacity/1048576 }}
}

#Function to get Computer Manufacturer & Model
function get-ComputerMake {
    param ( $computername = $env:COMPUTERNAME
    )
    Get-WmiObject -Class Win32_ComputerSystem -ComputerName $computername| Select-Object Manufacturer,Model
}


#Function to get OS Version
function get-ComputerOS {
    param ( $computername = $env:COMPUTERNAME
    )
    Get-WmiObject -Class Win32_OperatingSystem -ComputerName $computername| Select-Object Version
}



#Function to call other functions to get custom list of systems details
function get-SystemDetails {
    param ( $computername = $env:COMPUTERNAME
    )
    
    get-HardDisks -computername $computername | Format-Table -AutoSize
    get-Processor -computername $computername | Format-Table -AutoSize
    get-SerialNumber -computername $computername | Format-Table -AutoSize
    get-Memory -computername $computername | Format-Table -AutoSize
    get-ComputerMake -computername $computername | Format-Table -AutoSize
    get-ComputerOS -computername $computername | Format-Table -AutoSize
}