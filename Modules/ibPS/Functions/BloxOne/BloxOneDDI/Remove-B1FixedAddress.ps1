function Remove-B1FixedAddress {
    <#
    .SYNOPSIS
        Removes a fixed address from BloxOneDDI IPAM

    .DESCRIPTION
        This function is used to remove a fixed address from BloxOneDDI IPAM

    .PARAMETER IP
        The IP of the fixed address

    .PARAMETER Space
        Use this parameter to filter the list of fixed addresses by Space

    .PARAMETER id
        The id of the fixed address. Accepts pipeline input

    .EXAMPLE
        PS> Remove-B1FixedAddress -IP 10.10.10.200 -Space Global

    .EXAMPLE
        PS> Get-B1FixedAddress -IP 10.10.10.200 | Remove-B1FixedAddress

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        DHCP
    #>
    param(
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [String]$IP,
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [String]$Space,
      [Parameter(
        ValueFromPipelineByPropertyName = $true,
        ParameterSetName="With ID",
        Mandatory=$true
      )]
      [String]$id
    )

    process {
      if ($id) {
        $FixedAddress = Get-B1FixedAddress -id $id
      } else {
        $FixedAddress = Get-B1FixedAddress -IP $IP -Space $Space
      }

      if ($FixedAddress) {
        Invoke-CSP -Method DELETE -Uri $($FixedAddress.id) | Out-Null
        if (Get-B1FixedAddress -id $($FixedAddress.id)) {
          Write-Host "Error. Failed to delete fixed address: $($FixedAddress.address)" -ForegroundColor Red
        } else {
          Write-Host "Successfully deleted fixed address $($FixedAddress.address)" -ForegroundColor Green
        }
      } else {
        Write-Host "Error. Fixed Address does not exist: $IP$id" -ForegroundColor Red
      }
    }
}