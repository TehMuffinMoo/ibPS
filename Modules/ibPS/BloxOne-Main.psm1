<#
.SYNOPSIS
   BloxOne REST API for PowerShell
.DESCRIPTION
   A collection of PowerShell Cmdlets to interact with the InfoBlox BloxOne DDI & BloxOne Threat Defense REST API located at https://csp.infoblox.com/apidocs
   Also supports some limited Cmdlets for InfoBlox NIOS (Grid).
.NOTES
   Documentation located at: https://ibps.readthedocs.io
.AUTHOR
   Mat Cox
.VERSION
   https://github.com/TehMuffinMoo/ibPS/releases
.CHANGELOG
   https://raw.githubusercontent.com/TehMuffinMoo/ibPS/main/CHANGELOG.md
#>

## Enable Debug Logging (Mainly @splat outputs)
$Debug = $false

## Import Functions
$MiscellaneousFunctions = Get-ChildItem "$PSScriptRoot\Functions\Misc\*.ps1"
$B1PublicFunctions = Get-ChildItem "$PSScriptRoot\Functions\BloxOneDDI\*.ps1"
$B1PrivateFunctions = Get-ChildItem "$PSScriptRoot\Functions\BloxOneDDI\Private\*.ps1"
$B1TDPublicFunctions = Get-ChildItem "$PSScriptRoot\Functions\BloxOneTD\*.ps1"
$NIOSPublicFunctions = Get-ChildItem "$PSScriptRoot\Functions\NIOS\*.ps1"
$NIOSPrivateFunctions = Get-ChildItem "$PSScriptRoot\Functions\NIOS\Private\*.ps1"
$AdditionalFunctionsToImport = "Get-ibPSVersion","Query-NIOS"

foreach($FunctionToImport in @($B1PublicFunctions + $B1PrivateFunctions + $B1TDPublicFunctions + $NIOSPublicFunctions + $NIOSPrivateFunctions + $MiscellaneousFunctions)) {
  try {
    . $FunctionToImport.fullname
  } catch {
    Write-Error "Failed to import function $($FunctionToImport.fullname)"
  }
}

Export-ModuleMember -Function ($(@($B1PublicFunctions + $NIOSPublicFunctions) | Select-Object -ExpandProperty BaseName) + $AdditionalFunctionsToImport) -Alias *