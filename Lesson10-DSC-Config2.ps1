Configuration Lesson10DSCConfig2
{
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    Node "tempfile"
    {
        File CreateFile {
            DestinationPath = 'C:\Temp\IETTest.txt'
            Ensure = "Present"
            Contents = 'IET Config test!'
        }

        Service SNMPRunning #ResourceName
        {
            Name = "SNMP"
            StartupType = "Automatic"
            State = "Running"
            Ensure = "Present"
        }

    }
}

