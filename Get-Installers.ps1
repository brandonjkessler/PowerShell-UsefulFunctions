function Get-InstallFile{
	<#
	.SYNOPSIS
	Gets the Latest file of a specific name or file extension from a specified location.
	
	.DESCRIPTION
	Gets the Latest file of a specific name or file extension from a specified location.
	Useful for grabbing an installer from a known location without having to always specify the name.
	You can also specify part of the name, which is useful if the filename changes with each version.
	It will then return the installer results.
	
	.PARAMETER Path
	Path that the installer is located at.
	
	.PARAMETER Extension
	Extension of the installer to search for.
	Can be just the extension, or the '.' and extension, i.e. '.msi' or 'exe' are both valid.
	
	.PARAMETER Name
	Name or part of the name of the installer.
	Use in place of the Extension parameter.
	
	.EXAMPLE
	Get-InstallFile -Path ".\Files" -Extension ".exe"

	.EXAMPLE
	Get-InstallFile -Path "$dirFiles\Subfolder" -Name "Acrobat"

	.EXAMPLE
	Get-InstallFile -Path ".\Files" -Extension "msi"
	
	.NOTES
	General notes
	#>
	[cmdletbinding()]
	param(
		[Parameter(Mandatory,HelpMessage="Path to the installation file")]
		[ValidateScript({
			Test-Path -Path $PSItem
		})]
		[string]$Path,
		[Parameter(Mandatory,HelpMessage="File extension of the expected install file.",ParameterSetName="Extension")]
		[string]$Extension,
		[Parameter(Mandatory,HelpMessage="File name of the expected install file.",ParameterSetName="Name")]
		[string]$Name
	)
	

	switch ($PSBoundParameters){
		{$PSItem.ContainsKey('Extension')} {
			##-- Determine if the Extension provided has a '.' already, and if not, add one
			if($Extension -notmatch '^.*'){
				$filter = "*.$($Extension)"
			} else {
				$filter = "*$($Extension)"
			}
		}
		{$PSItem.ContainsKey('Name')} {
			$filter = "*$($Name)*"
		}
	}
	##-- Get the installer based onthe path and provided extension. If there are multiples, then select only the newest
	Write-Verbose -Message "Checking file matching $($filter) at $Path."
	$installer = Get-ChildItem -Path "$Path" -Filter $filter | Sort-Object -Property LastWriteTime -Descending | Select-Object -First 1
	if($null -eq $installer){
		Throw "Unable to locate an install that matches those arguments."
	} else {
		Return $installer
	}

}