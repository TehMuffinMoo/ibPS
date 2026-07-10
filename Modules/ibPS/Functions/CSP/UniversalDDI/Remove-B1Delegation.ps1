function Remove-B1Delegation {
    <#
    .SYNOPSIS
        Removes a Delegation from Universal DDI IPAM

    .DESCRIPTION
        This function is used to remove a Delegation from Universal DDI IPAM. This only accepts pipeline input.

    .PARAMETER Object
        The Delegation Object to remove. Accepts pipeline input

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

    .EXAMPLE
        PS> Get-B1Delegation -Subnet '10.10.10.0/24' | Remove-B1Delegation

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
        if (("$($SplitID[0])/$($SplitID[1])") -ne "federation/delegation") {
            Write-Error "Error. Unsupported pipeline object. This function only supports 'federation/delegation' objects as input"
            return $null
        }
      }

      if($PSCmdlet.ShouldProcess("$($Object.name) ($($Object.id))")){
        Write-Host "Removing Delegation: $($Object.Name).." -ForegroundColor Yellow
        $null = Invoke-CSP -Method "DELETE" -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($Object.id)" -Data $null | Out-Null
        $SI = Get-B1Delegation -id $($Object.id) 6> $null
        if ($SI) {
          Write-Host "Failed to remove Delegation: $($SI.Name)" -ForegroundColor Red
        } else {
          Write-Host "Successfully removed Delegation: $($Object.Name)" -ForegroundColor Green
        }
      }
    }
}