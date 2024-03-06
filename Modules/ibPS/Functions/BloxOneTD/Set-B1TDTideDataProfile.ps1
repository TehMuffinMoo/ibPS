function Set-B1TDTideDataProfile {
    <#
    .SYNOPSIS
        Updates an existing TIDE Data Profile

    .DESCRIPTION
        This function is used to update an existing TIDE Data Profile from BloxOne Threat Defense.

    .PARAMETER Name
        The name of the TIDE Data Profile to update

    .PARAMETER Description
        The description to apply to the data profile

    .PARAMETER RPZFeed
        The name of the BYOF RPZ Feed that this data profile will be included in

    .PARAMETER State
        This value indicates if the Data Profile is activated or deactivated.
    
    .PARAMETER DefaultTTLs
        This value indicates if to use the default TTL for threats (default is True)

    .EXAMPLE
        PS> Set-B1TDTideDataProfile -Name "My Profile" -Description "New Description" -RPZFeed "New RPZ Feed" -Active $true -DefaultTTL $false

        id          : 1133454765324:My-Profile
        name        : My Profile
        description : New Description
        policy      : default-csp
        default_ttl : False
        active      : True
        rpzfeedname : New RPZ Feed
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        BloxOne Threat Defense
    #>
    param(
        [Parameter(
            ValueFromPipelineByPropertyName = $true,
            Mandatory=$true
        )]
        [String]$Name,
        [String]$Description = "notset",
        [AllowEmptyString()]
        [String]$RPZFeed = "notset",
        [ValidateSet("Activated","Deactivated")]
        [String]$State,
        [ValidateSet("True","False")]
        [String]$DefaultTTL
    )

    process {
      $TIDEDataProfile = Get-B1TDTideDataProfile -Name $Name
      if (!$TIDEDataProfile) {
          Write-Host "Failed to find Data Profile with name: $Name." -ForegroundColor Red
      } else {
        if ($Description -ne "notset") {
          $TIDEDataProfile.description = $Description
        }
        if ($RPZFeed -ne "notset") {
          $TIDEDataProfile.rpzfeedname = $RPZFeed
        }
        if ($State) {
          switch ($State) {
              "Activated" {
                  $TIDEDataProfile.active = $true
              }
              "Deactivated" {
                  $TIDEDataProfile.active = $false
              }
          }
        }
        if ($DefaultTTL) {
          switch ($DefaultTTL) {
              "True" {
                  $TIDEDataProfile.default_ttl = $true
              }
              "False" {
                  $TIDEDataProfile.default_ttl = $false
              }
          }
        }
        $splat = $TIDEDataProfile | Select-Object -ExcludeProperty id | ConvertTo-Json -Compress
        $Result = Query-CSP -Method "PUT" -Uri "$(Get-B1CSPUrl)/tide/admin/v1/resources/dataprofiles/$Name" -Data $splat | Select-Object -ExpandProperty profile -ErrorAction SilentlyContinue
  
        if ($Result) {
          Write-Host "Successfully updated TIDE Data Profile: $Name" -ForegroundColor Green
        } else {
          Write-Host "Failed to update TIDE Data Profile: $Name" -ForegroundColor Red
        }
        return $Result
      }
    }
}