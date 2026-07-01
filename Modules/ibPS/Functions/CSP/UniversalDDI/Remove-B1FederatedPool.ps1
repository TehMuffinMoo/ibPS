function Remove-B1FederatedPool {
    <#
    .SYNOPSIS
        Removes a Federated Pool from Universal DDI IPAM

    .DESCRIPTION
        This function is used to remove a Federated Pool from Universal DDI IPAM

    .PARAMETER Name
        The name of the Federated Pool to remove

    .PARAMETER Realm
        The name of the Federated Realm associated with the Federated Pool to remove

    .PARAMETER Object
        The Federated Pool Object to remove. Accepts pipeline input

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

    .EXAMPLE
        PS> Remove-B1FederatedPool -Name "My Federated Pool" -Realm "My Federated Realm"

    .EXAMPLE
        PS> Get-B1FederatedPool -Name "My Federated Pool" -Realm "My Federated Realm" | Remove-B1FederatedPool

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
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [String]$Realm,
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
        if (("$($SplitID[0])/$($SplitID[1])") -ne "federation/federated_pool") {
            Write-Error "Error. Unsupported pipeline object. This function only supports 'federation/federated_pool' objects as input"
            return $null
        }
      } else {
        $Object = Get-B1FederatedPool -Name $Name -Realm $Realm -Strict
        if (!($Object)) {
            Write-Error "Unable to find Federated Pool: $($Name) in Federated Realm: $($Realm)."
            return $null
        }
      }

      if($PSCmdlet.ShouldProcess("$($Object.name) ($($Object.id))")){
        Write-Host "Removing Federated Pool: $($Object.Name).." -ForegroundColor Yellow
        $null = Invoke-CSP -Method "DELETE" -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($Object.id)" -Data $null | Out-Null
        $SI = Get-B1FederatedPool -id $($Object.id) 6> $null
        if ($SI) {
          Write-Host "Failed to remove Federated Pool: $($SI.Name)" -ForegroundColor Red
        } else {
          Write-Host "Successfully removed Federated Pool: $($Object.Name)" -ForegroundColor Green
        }
      }
    }
}