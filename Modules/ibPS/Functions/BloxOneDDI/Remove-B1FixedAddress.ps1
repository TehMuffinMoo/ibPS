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

    .Example
        Remove-B1FixedAddress -IP 10.10.10.200 -Space Global

    .Example
        Get-B1FixedAddress -IP 10.10.10.200 | Remove-B1FixedAddress
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DHCP
    #>
    param(
      [Parameter(
        ParameterSetName="noID",
        Mandatory=$true
      )]
      [String]$IP = $null,
      [Parameter(
        ParameterSetName="noID",
        Mandatory=$true
      )]
      [String]$Space,
      [Parameter(
        ValueFromPipelineByPropertyName = $true,
        ParameterSetName="ID",
        Mandatory=$true
      )]
      [String]$id
    )

    process {
      if ($id) {
        $FixedAddress = Get-B1FixedAddress -id $id
        if ($FixedAddress) {
          Query-CSP -Method DELETE -Uri $id | Out-Null
          if (Get-B1FixedAddress -id $id) {
            Write-Host "Error. Failed to delete fixed address with id: $id" -ForegroundColor Red
          } else {
            Write-Host "Successfully deleted fixed address $($FixedAddress.address) with id: $id" -ForegroundColor Green
          }
        } else {
          Write-Host "Error. Fixed Address does not exist with id: $id" -ForegroundColor Red
        }
      } else {
        $FixedAddress = Get-B1FixedAddress -IP $IP -Space $Space
        if ($FixedAddress) {
          Query-CSP -Method DELETE -Uri $FixedAddress.id
          if (Get-B1FixedAddress -IP $IP -Space $Space) {
            Write-Host "Error. Failed to delete fixed address with id: $id" -ForegroundColor Red
          } else {
            Write-Host "Successfully deleted fixed address with id: $id" -ForegroundColor Green
          }
        } else {
          Write-Host "Error. Fixed Address does not exist with IP: $IP in Space: $Space" -ForegroundColor Red
        }
      }
    }
}