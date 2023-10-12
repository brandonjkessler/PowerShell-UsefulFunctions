Function Write-CustomEventLog{
	[cmdletbinding()]
	param(
		[string]$Message,
		[int]$ID = 0001,
		[int]$Category = 0,
		[string]$EventSource = "Custom Event Log"
	)
    if ([System.Diagnostics.EventLog]::Exists('Application') -eq $False -or [System.Diagnostics.EventLog]::SourceExists($EventSource) -eq $False){
        New-EventLog -LogName Application -Source $EventSource  | Out-Null
    }
    Write-EventLog -LogName Application -Source $EventSource -EntryType Information -EventId $ID -Message $Message -Category $Category
}