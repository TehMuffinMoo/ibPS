function Remove-B1AddressReservation {
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
      [Parameter(Mandatory=$true)]
      [String]$Address,
      [Parameter(Mandatory=$true)]
      [String]$Space
    )
    $AddressReservation = Get-B1Address -Address $Address -Reserved
    if ($AddressReservation) {
        $Result = Query-CSP -Method "DELETE" -Uri $AddressReservation.id
            
        if (!($AddressReservation = Get-B1Address -Address $Address -Reserved)) {
            Write-Host "Address Reservation deleted successfully." -ForegroundColor Green
        } else {
            Write-Host "Failed to delete Address Reservation." -ForegroundColor Red
            break
        }
    } else {
        Write-Host "Error. Address reservation does not exist." -ForegroundColor Red
    }
}