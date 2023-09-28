﻿function Remove-B1AddressReservation {
    <#
    .SYNOPSIS
        Removes an address reservation from BloxOneDDI IPAM

    .DESCRIPTION
        This function is used to remove an address reservation from BloxOneDDI IPAM

    .PARAMETER Address
        The IP address of the reservation to remove

    .PARAMETER Space
        The IPAM space the reservation is contained in

    .Example
        Remove-B1AddressReservation -Address "10.0.0.1" -Space "Global"

    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        IPAM
    #>
    param(
      [Parameter(ParameterSetName="noID",Mandatory=$true)]
      [String]$Address,
      [Parameter(ParameterSetName="noID",Mandatory=$true)]
      [String]$Space,
      [Parameter(
        ValueFromPipelineByPropertyName = $true,
        ParameterSetName="ID",
        Mandatory=$true
      )]
      [String]$id
    )

    if ($id) {
      $AddressReservation = Get-B1Address -id $id -Reserved
    } else {
      $AddressReservation = Get-B1Address -Address $Address -Reserved
    }
    if ($AddressReservation) {
        Query-CSP -Method "DELETE" -Uri $($AddressReservation.id) | Out-Null

        $AR = Get-B1Address -id $($AddressReservation.id) -Reserved

        if (!($AR)) {
            Write-Host "Address Reservation deleted successfully: $($AddressReservation.address)." -ForegroundColor Green
        } else {
            Write-Host "Failed to delete Address Reservation: $($AR.address)" -ForegroundColor Red
            break
        }
    } else {
        Write-Host "Error. Address reservation does not exist." -ForegroundColor Red
    }
}