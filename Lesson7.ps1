#Get the RDP Thumbprint
Get-WmiObject -class “Win32_TSGeneralSetting” -Namespace root\cimv2\terminalservices


#Get a list of all Certificate stores
 Get-ChildItem cert:

#View all local machine stores
Get-ChildItem cert:\LocalMachine\


#View all local machine Personal certs
Get-ChildItem cert:\LocalMachine\My\


#View all local machine remote desktop certs
Get-ChildItem "cert:\LocalMachine\Remote Desktop\FD05DBC3431F8A6FB749035A928E3D3CF647C367"
$cert = Get-ChildItem "cert:\LocalMachine\Remote Desktop\FD05DBC3431F8A6FB749035A928E3D3CF647C367"

 
#Creates a FQDN from computer name and domain
$computerfqdn = ($env:COMPUTERNAME)+"."+$env:USERDNSDOMAIN
#Creates a self signed cert in the local machine personal store
$cert = New-SelfSignedCertificate -certstorelocation cert:\localmachine\My -DnsName $computerfqdn
#Gets the RDP settings of local system
$tsgs = Get-WmiObject -class "Win32_TSGeneralSetting" -Namespace root\cimv2\terminalservices -Filter "TerminalName='RDP-tcp'"
# Sets the Certificate used by RDP
Set-WmiInstance -path $tsgs.__path -argument @{SSLCertificateSHA1Hash=$cert.Thumbprint}
#Restart RDP service
Restart-Service TermService -Force



function get-RDPcert 
{
  #Run wmi command to get the applied certificate used by RDP
  $RDPCerts = Get-WmiObject -class “Win32_TSGeneralSetting” -Namespace root\cimv2\terminalservices | Select-Object TerminalName, TerminalProtocol, Transport, CertificateName, @{n='Thumbprint';e={($_.SSLCertificateSHA1Hash)}}, __PATH
  $RDPCerts
}


function check-Cert
{
    #To run via invoke-command example to check personal store for a thumbprint if it is self signed: 'Invoke-Command -ComputerName tcaweb -ScriptBlock ${Function:check-Cert}  -ArgumentList 'SystemPersonal','11B8EC4256ED199E2863564DF30B3B1153766252',$true'
    #Parameter to check the computers Remote Desktop or Personal certificate store, check by Thumbprint, or if self signed check
    Param(                 
        [Parameter(Mandatory=$true, Position = 0)]
        [ValidateSet('RDP','SystemPersonal')]
        [string]$Store,
        [Parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$True, Position = 1)] 
        $Thumbprint,
	[Parameter(Position = 2)]
        [switch]$SelfSignedCheck

        )
    #Gloabl variable to output found certificate
    $global:certs = $null
    #Swticht to check the defined certificate store and pull all certs or one by thumbprint
    Switch ($Store){
        'RDP'{
            if ($Thumbprint -and !$SelfSignedCheck){  Get-ChildItem "Cert:\LocalMachine\Remote Desktop\$Thumbprint"}
            else{$certs = Get-ChildItem "Cert:\LocalMachine\Remote Desktop\"}

        }
        'SystemPersonal'{
            if ($Thumbprint -and !$SelfSignedCheck){  Get-ChildItem "Cert:\LocalMachine\My\$Thumbprint"}
            else{$certs = Get-ChildItem "Cert:\LocalMachine\My\"}
        }
    }
    if ($SelfSignedCheck)
    {
        $global:selfSignCerts = @()
        #Creates a FQDN from computer name and domain
        $computerfqdn = ($env:COMPUTERNAME)+"."+$env:USERDNSDOMAIN
        #Checks each certificate in the store if the Subject name is the same as Issuer name and if Issuer contains the computer FQDN 
        foreach ($cert in $certs)
        {
                #If thumbprint is provided it will check if it is self signed
                if($Thumbprint)
                {
                $cert.Subject -eq $cert.Issuer -and $cert.Issuer -contains (('CN=')+$computerfqdn) -and $cert.Thumbprint -eq $Thumbprint
                }
                #Will check all certs if they are self signed
                else
                {
                    if ($cert.Subject -eq $cert.Issuer -and $cert.Issuer -contains (('CN=')+$computerfqdn) )
                    {$global:selfSignCerts += $cert}
                    #Outputs the results
                    $selfSignCerts | Format-List
                }
        }
    }
}


function remove-Cert {
    #Parameter to remove cert from the computers Remote Desktop or Personal certificate store with provided Thumbprint
    Param(                 
        [Parameter(Mandatory=$true, Position = 0)]
        [ValidateSet('RDP','SystemPersonal')]
        [string]$Store,
        [Parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$True, Mandatory=$true, Position = 1)] 
        $Thumbprint
        )

    Switch ($Store){
        'RDP'{
            Remove-Item "Cert:\LocalMachine\Remote Desktop\$Thumbprint"
        }
        'SystemPersonal'{
            Remove-Item "Cert:\LocalMachine\My\$Thumbprint"
        }
    }
}