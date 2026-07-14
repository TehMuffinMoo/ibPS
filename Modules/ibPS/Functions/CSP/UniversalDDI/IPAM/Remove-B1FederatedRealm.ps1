function Remove-B1FederatedRealm {
    <#
    .SYNOPSIS
        Removes a Federated Realm from Universal DDI IPAM

    .DESCRIPTION
        This function is used to remove a Federated Realm from Universal DDI IPAM

    .PARAMETER Name
        The name of the Federated Realm to remove

    .PARAMETER Object
        The Federated Realm Object to remove. Accepts pipeline input

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

    .EXAMPLE
        PS> Remove-B1FederatedRealm -Name "My Federated Realm"

    .EXAMPLE
        PS> Get-B1FederatedRealm -Name "My Federated Realm" | Remove-B1FederatedRealm

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        IPAM
    #>
    [CmdletBinding(
      SupportsShouldProcess,
      ConfirmImpact = 'High'
    )]
    param(
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [String]$Name,
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
        if (("$($SplitID[0])/$($SplitID[1])") -ne "federation/federated_realm") {
            Write-Error "Error. Unsupported pipeline object. This function only supports 'federation/federated_realm' objects as input"
            return $null
        }
      } else {
        $Object = Get-B1FederatedRealm -Name $Name -Strict
        if (!($Object)) {
            Write-Error "Unable to find Federated Realm: $($Name)."
            return $null
        }
      }

      if($PSCmdlet.ShouldProcess("$($Object.name) ($($Object.id))")){
        Write-Host "Removing Federated Realm: $($Object.Name).." -ForegroundColor Yellow
        $null = Invoke-CSP -Method "DELETE" -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($Object.id)" -Data $null | Out-Null
        $SI = Get-B1FederatedRealm -id $($Object.id) 6> $null
        if ($SI) {
          Write-Host "Failed to remove Federated Realm: $($SI.Name)" -ForegroundColor Red
        } else {
          Write-Host "Successfully removed Federated Realm: $($Object.Name)" -ForegroundColor Green
        }
      }
    }
}