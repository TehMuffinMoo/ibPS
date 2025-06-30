function Set-B1TideDataProfile {
    <#
    .SYNOPSIS
        Updates an existing TIDE Data Profile

    .DESCRIPTION
        This function is used to update an existing TIDE Data Profile from Infoblox Threat Defense.

    .PARAMETER Name
        The name of the TIDE Data Profile to update

    .PARAMETER Description
        The description to apply to the data profile

    .PARAMETER RPZFeed
        The name of the BYOF RPZ Feed that this data profile will be included in

    .PARAMETER State
        This value indicates if the Data Profile is activated or deactivated.

    .PARAMETER DefaultTTL
        This value indicates if to use the default TTL for threats

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
        PS> Set-B1TideDataProfile -Name "My Profile" -Description "New Description" -RPZFeed "New RPZ Feed" -Active $true -DefaultTTL $false

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
        Infoblox Threat Defense
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Medium'
    )]
    param(
        [Parameter(
            ValueFromPipelineByPropertyName = $true,
            Mandatory=$true
        )]
        [String]$Name,
        [String]$Description,
        [String]$RPZFeed,
        [ValidateSet("Activated","Deactivated")]
        [String]$State,
        [ValidateSet("True","False")]
        [String]$DefaultTTL,
        [Switch]$Force
    )

    process {
      $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
      $TIDEDataProfile = Get-B1TideDataProfile -Name $Name
      if (!$TIDEDataProfile) {
          Write-Host "Failed to find Data Profile with name: $Name." -ForegroundColor Red
      } else {
        if ($Description) {
          $TIDEDataProfile.description = $Description
        }
        if ($RPZFeed) {
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
        $JSON = $TIDEDataProfile | Select-Object * -ExcludeProperty id | ConvertTo-Json -Compress

        if($PSCmdlet.ShouldProcess("Update TIDE Data Profile:`n$(JSONPretty($JSON))","Update TIDE Data Profile: $($TIDEDataProfile.name)",$MyInvocation.MyCommand)){
            $Result = Invoke-CSP -Method "PUT" -Uri "$(Get-B1CSPUrl)/tide/admin/v1/resources/dataprofiles/$Name" -Data $JSON | Select-Object -ExpandProperty profile -ErrorAction SilentlyContinue
            if ($Result) {
            Write-Host "Successfully updated TIDE Data Profile: $Name" -ForegroundColor Green
            } else {
            Write-Host "Failed to update TIDE Data Profile: $Name" -ForegroundColor Red
            }
            return $Result
        }
      }
    }
}