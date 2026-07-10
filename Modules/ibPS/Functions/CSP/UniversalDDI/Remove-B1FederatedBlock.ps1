function Remove-B1FederatedBlock {
    <#
    .SYNOPSIS
        Removes a Federated Block from Universal DDI IPAM

    .DESCRIPTION
        This function is used to remove a Federated Block from Universal DDI IPAM. This only accepts pipeline input.

    .PARAMETER Object
        The Federated Block Object to remove. Accepts pipeline input

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

    .EXAMPLE
        PS> Get-B1FederatedBlock -Subnet '10.10.10.0/24' | Remove-B1FederatedBlock

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
      [Parameter(
        ValueFromPipeline = $true,
        Mandatory=$true
      )]
      [System.Object]$Object,
      [Switch]$Force
    )

    process {
      $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
      if ($Object) {
        $SplitID = $Object.id.split('/')
        if (("$($SplitID[0])/$($SplitID[1])") -ne "federation/federated_block") {
            Write-Error "Error. Unsupported pipeline object. This function only supports 'federation/federated_block' objects as input"
            return $null
        }
      }

      if($PSCmdlet.ShouldProcess("$($Object.name) ($($Object.id))")){
        Write-Host "Removing Federated Block: $($Object.Name).." -ForegroundColor Yellow
        $null = Invoke-CSP -Method "DELETE" -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($Object.id)" -Data $null | Out-Null
        $SI = Get-B1FederatedBlock -id $($Object.id) 6> $null
        if ($SI) {
          Write-Host "Failed to remove Federated Block: $($SI.Name)" -ForegroundColor Red
        } else {
          Write-Host "Successfully removed Federated Block: $($Object.Name)" -ForegroundColor Green
        }
      }
    }
}