function New-B1AddressReservation {
    <#
    .SYNOPSIS
        Creates a new address reservation in BloxOneDDI IPAM

    .DESCRIPTION
        This function is used to create a new address reservation in BloxOneDDI IPAM

    .PARAMETER Address
        The IP address for the new reservation

    .PARAMETER Name
        The name for the new reservation

    .PARAMETER Description
        The description of the new reservation

    .PARAMETER Space
        The IPAM space for the new reservation to be placed in

    .Example
        New-B1AddressReservation -Address "10.0.0.1" -Name "MyReservedHost" -Description "My Reserved Host" -Space "Global"

    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        IPAM
    #>
    param(
      [Parameter(Mandatory=$true)]
      [String]$Address,
      [Parameter(Mandatory=$true)]
      [String]$Name,
      [Parameter(Mandatory=$true)]
      [String]$Description,
      [Parameter(Mandatory=$true)]
      [String]$Space
    )
    if (!(Get-B1Address -Address $Address -Reserved)) {
        $splat = @{
	        "space" = (Get-B1Space -Name $Space -Strict).id
	        "address" = $Address
	        "comment" = $Description
	        "names" = @(@{
			        "name" = $Name
			        "type" = "user"
	        })
        }
        $splat = ConvertTo-Json($splat) -Depth 2
        $Result = Query-CSP -Method "POST" -Uri "ipam/address" -Data $splat

        if (($Result | Select-Object -ExpandProperty result).address -eq $Address) {
            Write-Host "Address Reservation created successfully." -ForegroundColor Green
            return $Result | Select-Object -ExpandProperty result
        } else {
            Write-Host "Error. Failed to create Address Reservation $Subnet." -ForegroundColor Red
            break
        }
    } else {
        Write-Host "Address already exists." -ForegroundColor Red
    }
}