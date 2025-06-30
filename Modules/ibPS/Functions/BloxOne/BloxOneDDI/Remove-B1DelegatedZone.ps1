function Remove-B1DelegatedZone {
    <#
    .SYNOPSIS
        Removes a Delegated Zone from BloxOneDDI

    .DESCRIPTION
        This function is used to remove a Delegated Zone from BloxOneDDI

    .PARAMETER FQDN
        The FQDN of the zone to remove

    .PARAMETER View
        The DNS View the zone is located in

    .PARAMETER Object
        The Delegated Zone object. Accepts pipeline input

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

    .EXAMPLE
        PS> Remove-B1DelegatedZone -FQDN "delegated.mycompany.corp" -View "default"

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        DNS
    #>
    [CmdletBinding(
      SupportsShouldProcess,
      ConfirmImpact = 'High'
    )]
    param(
      [Parameter(Mandatory=$true,ParameterSetName="Default")]
      [String]$FQDN,
      [Parameter(Mandatory=$true,ParameterSetName="Default")]
      [System.Object]$View,
      [Parameter(
        ValueFromPipeline = $true,
        ParameterSetName="Object",
        Mandatory=$true
      )]
      [System.Object]$Object,
      [Switch]$Force
    )

    process {
      $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
      if ($Object) {
        $SplitID = $Object.id.split('/')
        if (("$($SplitID[0])/$($SplitID[1])") -ne "dns/delegation") {
            Write-Error "Error. Unsupported pipeline object. This function only supports 'dns/delegation' objects as input"
            return $null
        }
      } else {
          $Object = Get-B1DelegatedZone -FQDN $FQDN -Strict -View $View
          if (!($Object)) {
              Write-Error "Unable to find Delegated Zone: $($FQDN) in DNS View: $($View)"
              return $null
          }
          if ($Object.count -gt 1) {
              Write-Error "Multiple Delegated Zones were found, to remove more than one Delegated Zone you should pass those objects using pipe instead."
              return $null
          }
      }
      if($PSCmdlet.ShouldProcess("$($Object.fqdn) ($($Object.id))")){
        $null = Invoke-CSP -Method "DELETE" -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($Object.id)" | Out-Null
        $B1Zone = Get-B1DelegatedZone -id $($Object.id)
        if ($B1Zone) {
            Write-Host "Error. Failed to delete Delegated Zone: $($B1Zone.fqdn)" -ForegroundColor Red
        } else {
            Write-Host "Successfully deleted Delegated Zone: $($Object.fqdn)" -ForegroundColor Green
        }
      }
    }
}