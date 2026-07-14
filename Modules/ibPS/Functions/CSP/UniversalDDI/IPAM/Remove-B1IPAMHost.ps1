function Remove-B1IPAMHost {
    <#
    .SYNOPSIS
        Removes an IPAM Host Object from Universal DDI

    .DESCRIPTION
        This function is used to remove an IPAM Host Object from Universal DDI. This only accepts pipeline input.

    .PARAMETER Object
        The host object to remove. Accepts pipeline input

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

    .EXAMPLE
        PS> Get-B1IPAMHost "my-host" | Remove-B1IPAMHost

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        IPAM

    .FUNCTIONALITY
        DHCP
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
        if (("$($SplitID[0])/$($SplitID[1])") -ne "ipam/host") {
            Write-Error "Error. Unsupported pipeline object. This function only supports 'ipam/host' objects as input"
            return $null
        }
      }

      if($PSCmdlet.ShouldProcess("$($Object.name) ($($Object.id))")){
        Write-Host "Removing IPAM Host: $($Object.name) ($($Object.id)).." -ForegroundColor Yellow
        $null = Invoke-CSP -Method "DELETE" -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($Object.id)"
        $B1R = Get-B1IPAMHost -id $($Object.id)
        if ($B1R) {
          Write-Host "Error. Failed to remove IPAM Host: $($B1R.name) ($($B1R.id))" -ForegroundColor Red
        } else {
          Write-Host "Successfully removed IPAM Host: $($Object.name) ($($Object.id))" -ForegroundColor Green
        }
      }
    }
}