function Get-InstalledAppsRegistry{
    <#
    .SYNOPSIS
    Search the Registry for Application name.
    
    .DESCRIPTION
    Searches the registry uninstall locations for the Application. Returns the results.
    
    .PARAMETER App
    Name of the Application to search for.
    
    .EXAMPLE
    Get-InstalledAppsRegistry -App 'Acrobat'
    
    .NOTES
    General notes
    #>
    [cmdletbinding()]
    Param(
        [Alias("App")]
        [Parameter(Position=0,Mandatory=$true)]
        [String]$Name
    )

    ## Create Arry of Applications
    Write-Verbose -Message "Now searching for $Name in the registry."
    $Apps = Get-ItemProperty 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*','HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*' | Where-Object{$_.DisplayName -like "*$Name*"} # 32 Bit
    Return $Apps

}

function Get-InstalledAppsCim {
    <#
    .SYNOPSIS
    Searches through CIM for specified application.
    
    .DESCRIPTION
    Searches through CIM for specified application. Uses the Class Win32_InstalledWin32Program. Returns the Results.
    
    .PARAMETER App
    Name of the Application to search for.
    
    .EXAMPLE
    Get-InstalledAppsCim -App 'Acrobat'
    
    .NOTES
    General notes
    #>
    [cmdletbinding()]
    Param(
        [Alias("App")]
        [Parameter(Position=0,Mandatory=$true)]
        [String]$Name
    )

    Write-Verbose -Message "Now searching for $Name in Win32_InstalledWin32Program Class."
    $Apps = Get-CimInstance -ClassName Win32_InstalledWin32Program | Where-Object{$_.Name -match "$Name"}
    Return $Apps
}