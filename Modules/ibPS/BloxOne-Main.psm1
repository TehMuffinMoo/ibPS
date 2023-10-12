<#
.SYNOPSIS
   BloxOne REST API for PowerShell
.DESCRIPTION
   A collection of PowerShell Cmdlets to interact with the InfoBlox BloxOne DDI REST API located at https://csp.infoblox.com/apidocs
   Also supports some limited Cmdlets for InfoBlox NIOS (Grid).
.NOTES
   Work in progress, some cmdlets are limited in their nature.
.AUTHOR
   Mat Cox
.VERSION
   v1.9
.CHANGELOG
   v0.1 - 17/05/2022 - Initial commit
   v0.2 - 18/05/2022 - Addition of a number of new Cmdlets, still developing..
   v0.3 - 26/05/2022 - Bug fixes, addition of Set-B1Subnet & Set-B1AddressBlock
   v0.4 - 30/05/2022 - Added hard dependency to check API key for BloxOne is stored.
   v0.5 - 06/07/2022 - Various changes, cleanup, update cmdlet docs, etc.
   v0.6 - 26/07/2022 - Finally a new release.. lots of changes :)
   v0.7 - 24/10/2022 - I guess it's that time again
   v0.8 - 20/04/2023 - Definitely in need of a new version no.
   v0.9 - 25/08/2023 - Complete re-write/re-structure, add contextual help info (Get-Help) for all cmdlets & basic prep for implementing pipeline input
   v1.9 - 25/08/2023 - Align version numbers with module
#>

## Enable Debug Logging (Mainly @splat outputs)
$Debug = $false

## Import Functions
$B1PublicFunctions = Get-ChildItem "$PSScriptRoot\Functions\BloxOneDDI\*.ps1"
$B1PrivateFunctions = Get-ChildItem "$PSScriptRoot\Functions\BloxOneDDI\Private\*.ps1"
$NIOSPublicFunctions = Get-ChildItem "$PSScriptRoot\Functions\NIOS\*.ps1"
$NIOSPrivateFunctions = Get-ChildItem "$PSScriptRoot\Functions\NIOS\Private\*.ps1"
$AdditionalFunctionsToImport = "Get-ibPSVersion"

foreach($FunctionToImport in @($B1PublicFunctions + $B1PrivateFunctions + $NIOSPublicFunctions + $NIOSPrivateFunctions)) {
  try {
    . $FunctionToImport.fullname
  } catch {
    Write-Error "Failed to import function $($FunctionToImport.fullname)"
  }
}

function DeprecationNotice {
  param (
    $Date,
    $Command,
    $AlternateCommand
  )
  $ParsedDate = [datetime]::parseexact($Date, 'dd/MM/yy', $null)
  if ($ParsedDate -gt (Get-Date)) {
    Write-Host "Cmdlet Deprecation Notice! $Command will be deprecated on $Date. Please switch to using $AlternateCommand before this date." -ForegroundColor Yellow
  } else {
    Write-Host "Cmdlet was deprecated on $Date. $Command will likely no longer work. Please switch to using $AlternateCommand instead." -ForegroundColor Red
  }
}

function Get-ibPSVersion {
  (Get-Module -ListAvailable -Name ibPS).Version.ToString()
}

Export-ModuleMember -Function ($(@($B1PublicFunctions + $NIOSPublicFunctions) | Select-Object -ExpandProperty BaseName) + $AdditionalFunctionsToImport) -Alias *