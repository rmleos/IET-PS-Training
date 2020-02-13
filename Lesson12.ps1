
$processes = "Microsoft.Photos", "splunkd", "OUTLOOK", "Slack"

foreach ($item in $processes)
{
    Stop-Process -Name $item -Confirm:$false -Force
}