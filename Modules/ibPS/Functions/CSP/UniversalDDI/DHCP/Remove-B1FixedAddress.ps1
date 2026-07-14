function Remove-B1FixedAddress {
    <#
    .SYNOPSIS
        Removes a fixed address from Universal DDI IPAM

    .DESCRIPTION
        This function is used to remove a fixed address from Universal DDI IPAM

    .PARAMETER IP
        The IP of the fixed address

    .PARAMETER Space
        Use this parameter to filter the list of fixed addresses by Space

    .PARAMETER Object
        The fixed address object to remove. Accepts pipeline input

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

    .EXAMPLE
        PS> Remove-B1FixedAddress -IP 10.10.10.200 -Space Global

    .EXAMPLE
        PS> Get-B1FixedAddress -IP 10.10.10.200 | Remove-B1FixedAddress

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        DHCP
    #>
    [CmdletBinding(
      SupportsShouldProcess,
      ConfirmImpact = 'High'
    )]
    param(
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [String]$IP,
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
          if (("$($SplitID[0])/$($SplitID[1])") -ne "dhcp/fixed_address") {
              Write-Error "Error. Unsupported pipeline object. This function only supports 'dhcp/fixed_address' objects as input"
              return $null
          }
      } else {
          $Object = Get-B1FixedAddress -IP $IP -Space $Space
          if (!($Object)) {
              Write-Error "Unable to find Fixed Address: $($IP) in IP Space: $($Space)"
              return $null
          }
      }

      if($PSCmdlet.ShouldProcess("$($Object.address) ($($Object.id))")){
        $null = Invoke-CSP -Method DELETE -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($Object.id)" | Out-Null
        if (Get-B1FixedAddress -id $($Object.id)) {
          Write-Host "Error. Failed to delete fixed address: $($Object.address)" -ForegroundColor Red
        } else {
          Write-Host "Successfully deleted fixed address $($Object.address)" -ForegroundColor Green
        }
      }
    }
}