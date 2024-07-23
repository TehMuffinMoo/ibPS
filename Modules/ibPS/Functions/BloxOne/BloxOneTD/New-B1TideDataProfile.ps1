function New-B1TideDataProfile {
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

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
        PS> New-B1TideDataProfile -Name "My Profile" -Description "My Data Profile" -RPZFeed "threat_feed_one" -DefaultTTL $true

        Successfully created TIDE Data Profile: My Profile

        id          : 01234546567563324:My-Profile
        name        : My Profile
        description : My Data Profile
        policy      : default-csp
        default_ttl : True
        active      : True
        rpzfeedname : threat_feed_one

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        BloxOne Threat Defense
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Medium'
    )]
    param(
        [Parameter(Mandatory=$true)]
        [String]$Name,
        [Parameter(Mandatory=$true)]
        [String]$Description,
        [String]$RPZFeed,
        [bool]$DefaultTTL = $true,
        [Switch]$Force
    )
    $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
    $TIDEDataProfile = Get-B1TideDataProfile -Name $Name
    if ($TIDEDataProfile) {
        Write-Error "A data profile with this name already exists: $Name."
        break
    } else {
      $TIDEDataProfile = @{
        "name" = $Name
        "description" = $Description
        "rpzfeedname" = $RPZFeed
        "default_ttl" = $DefaultTTL
      }
      $JSON = $TIDEDataProfile | ConvertTo-Json -Compress

      if($PSCmdlet.ShouldProcess("Create new TIDE Data Profile:`n$(JSONPretty($JSON))","TIDE Data Profile: $($Name)",$MyInvocation.MyCommand)){
        $Result = Invoke-CSP -Method "POST" -Uri "$(Get-B1CSPUrl)/tide/admin/v1/resources/dataprofiles" -Data $JSON | Select-Object -ExpandProperty profile -ErrorAction SilentlyContinue

        if ($Result) {
            Write-Host "Successfully created TIDE Data Profile: $Name" -ForegroundColor Green
        } else {
            Write-Host "Failed to create TIDE Data Profile: $Name" -ForegroundColor Red
        }
        return $Result
      }
    }
}