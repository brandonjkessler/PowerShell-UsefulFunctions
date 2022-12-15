function Wait-ApplicationExecute {
    <#
    .SYNOPSIS
    Waits for an application to finish executing. 
    
    .DESCRIPTION
    Useful for things like msiexec. Place this function in your script to test if an application is still running.
    The Name parameter requires a name that matches when using `Get-Process -Name`, i.e. `code` for VS Code.

    
    .PARAMETER Name
    Name of the application to wait on. Note, this must match the app name in Task Manager. This does accept a value from pipeline

    .PARAMETER TimeOutSeconds
    Sets the amount of time in seconds before it exits.
    
    .EXAMPLE
    Wait-ApplicationExecute -Name 'code'
    
    .NOTES
    General notes
    #>
    [cmdletbinding()]
    Param(
        [Parameter(Position=0,Mandatory=$true,HelpMessage='Name of the application to wait on. Note, this must match the app name in Task Manager.',ValueFromPipelineByPropertyName=$true)]
        [string]$Name,
        [Parameter(Position=1,Mandatory=$false,HelpMessage='Time, in seconds, to wait for a timeout')]
        [ValidateScript({if($_ -gt 0){$true}else{throw "$_ is not greater than 0."}})]
        [int]$TimeOutSeconds
    )

    $StartTime = Get-Date
    Write-Verbose "Starting wait process at $StartTime. Checking for the application `"$Name`"."

    While($null -ne (Get-Process -Name "$Name")){
        $CurrentTime = Get-Date
        if((0 -ne $TimeOutSeconds) -and ($CurrentTime -ge $StartTime.AddSeconds($TimeOutSeconds))){
            Write-Error "Reached $TimeOutSeconds seconds. Wait timed out."
            Exit 1
        } else {
            Write-Verbose "$Name is still running. Waiting 5 seconds and testing again."
            Start-Sleep -Seconds 5
        }
        
    }

    Write-Host "$Name is not running or was not found. If this is an error, please verify the name of the application."
    
    $EndTime = Get-Date
    $TotalTime = New-TimeSpan -Start $StartTime -End $EndTime
    Write-Host "Total time waited: $TotalTime" -ForegroundColor Green
}

