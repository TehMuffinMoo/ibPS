<#
.SYNOPSIS
   Infoblox PowerShell Module for Universal DDI & Threat Defense
.DESCRIPTION
   A collection of PowerShell Cmdlets to interact with Infoblox Universal DDI & Threat Defense REST API located at https://csp.infoblox.com/apidoc
   Also supports some limited Cmdlets for Infoblox NIOS (Grid).
.NOTES
   Documentation located at: https://ibps.readthedocs.io
.AUTHOR
   Mat Cox
.VERSION
   https://github.com/TehMuffinMoo/ibPS/releases
.CHANGELOG
   https://raw.githubusercontent.com/TehMuffinMoo/ibPS/main/CHANGELOG.md
#>

## Import Functions
$MiscellaneousFunctions = Get-ChildItem "$PSScriptRoot\Functions\Misc\*.ps1"
$B1PublicFunctions = Get-ChildItem "$PSScriptRoot\Functions\CSP" -Exclude Private | Get-ChildItem -Recurse -File
$B1PrivateFunctions = Get-ChildItem "$PSScriptRoot\Functions\CSP\Private\*.ps1" -File
$NIOSPublicFunctions = Get-ChildItem "$PSScriptRoot\Functions\NIOS" -Exclude Private | Get-ChildItem -Recurse -File
$NIOSPrivateFunctions = Get-ChildItem "$PSScriptRoot\Functions\NIOS\Private\*.ps1" -File
$AdditionalFunctionsToExport = @('Invoke-CSP')

foreach($FunctionToImport in @($B1PublicFunctions + $B1PrivateFunctions + $NIOSPublicFunctions + $NIOSPrivateFunctions + $MiscellaneousFunctions)) {
  try {
    . $FunctionToImport.fullname
  } catch {
    Write-Error "Failed to import function $($FunctionToImport.fullname)"
  }
}

if ($ENV:IBPSDevelopment -eq "Enabled") {
   $AdditionalFunctionsToExport += DevelopmentFunctions
}
if ($ENV:IBPSDebug -eq "Enabled") {
   $DebugPreference = 'Continue'
} else {
   $DebugPreference = 'SilentlyContinue'
}

Initialize-NIOSConfig
Initialize-B1Config

Export-ModuleMember -Function ($(@($B1PublicFunctions + $NIOSPublicFunctions + ($MiscellaneousFunctions | Where-Object {$_.BaseName -ne 'Misc'})) | Select-Object -ExpandProperty BaseName) + $AdditionalFunctionsToExport) -Alias *
