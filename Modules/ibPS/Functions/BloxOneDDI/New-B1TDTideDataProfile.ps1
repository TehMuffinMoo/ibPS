function New-B1TDTideDataProfile {
    <#
    .SYNOPSIS
        Creates a new TIDE Data Profile

    .DESCRIPTION
        This function is used to create a new TIDE Data Profile in BloxOne Threat Defense.

    .PARAMETER Name
        The name of the TIDE Data Profile to create

    .PARAMETER Description
        The description of the TIDE Data Profile to create

    .PARAMETER RPZFeed
        The name of the BYOF RPZ Feed that this data profile will be included in

    .PARAMETER DefaultTTL
        This boolean value indicates if to use the default TTL for threats (default is true)

    .EXAMPLE
        PS> New-B1TDTideDataProfile -Name "My Profile" -Description "My Data Profile" -RPZFeed "threat_feed_one" -DefaultTTL $false
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        BloxOne Threat Defense
    #>
    param(
        [Parameter(Mandatory=$true)]
        [String]$Name,
        [Parameter(Mandatory=$true)]
        [String]$Description,
        [String]$RPZFeed,
        [bool]$DefaultTTL = $true
    )

    $TIDEDataProfile = Get-B1TDTideDataProfile -Name $Name
    if ($TIDEDataProfile) {
        Write-Host "A data profile with this name already exists: $Name." -ForegroundColor Red
    } else {
      $TIDEDataProfile = @{
        "name" = $Name
        "description" = $Description
        "rpzfeedname" = $RPZFeed
        "default_ttl" = $DefaultTTL
      }
      $splat = $TIDEDataProfile | ConvertTo-Json -Compress
      $Result = Query-CSP -Method "POST" -Uri "$(Get-B1CSPUrl)/tide/admin/v1/resources/dataprofiles" -Data $splat | Select-Object -ExpandProperty profile -ErrorAction SilentlyContinue
  
      if ($Result) {
        Write-Host "Successfully created TIDE Data Profile: $Name" -ForegroundColor Green
      } else {
        Write-Host "Failed to create TIDE Data Profile: $Name" -ForegroundColor Red
      }
      return $Result
    }
}