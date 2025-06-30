function Remove-B1Range {
    <#
    .SYNOPSIS
        Removes a DHCP Range from Universal DDI

    .DESCRIPTION
        This function is used to remove a DHCP Range from Universal DDI

    .PARAMETER StartAddress
        The start address of the DHCP Range

    .PARAMETER EndAddress
        The end address of the DHCP Range

    .PARAMETER Space
        Use this parameter to filter the list of Address Blocks by Space

    .PARAMETER Object
        The range object to remove. Accepts pipeline input

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

    .EXAMPLE
        PS> Remove-B1Range -StartAddress "10.250.20.20" -EndAddress "10.250.20.100" -Space "Global"

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
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [String]$StartAddress,
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [String]$EndAddress,
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [String]$Space,
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
        if (("$($SplitID[0])/$($SplitID[1])") -ne "ipam/range") {
            Write-Error "Error. Unsupported pipeline object. This function only supports 'ipam/range' objects as input"
            return $null
        }
      } else {
          $Object = Get-B1Range -StartAddress $StartAddress -EndAddress $EndAddress -Space $Space
          if (!($Object)) {
              Write-Error "Unable to find DHCP Range: $($StartAddress)-$($EndAddress) in IP Space: $($Space)."
              return $null
          }
      }

      if($PSCmdlet.ShouldProcess("$($Object.start) - $($Object.end) ($($Object.id))")){
        Write-Host "Removing DHCP Range: $($Object.start) - $($Object.end).." -ForegroundColor Yellow
        $null = Invoke-CSP -Method "DELETE" -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($Object.id)"
        $B1R = Get-B1Range -id $($Object.id)
        if ($B1R) {
          Write-Host "Error. Failed to remove DHCP Range: $($B1R.start) - $($B1R.end)" -ForegroundColor Red
        } else {
          Write-Host "Successfully removed DHCP Range: $($Object.start) - $($Object.end)" -ForegroundColor Green
        }
      }
    }
}