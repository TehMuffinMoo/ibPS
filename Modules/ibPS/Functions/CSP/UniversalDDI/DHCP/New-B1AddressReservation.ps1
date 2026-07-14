function New-B1AddressReservation {
    <#
    .SYNOPSIS
        Creates a new address reservation in Universal DDI IPAM

    .DESCRIPTION
        This function is used to create a new address reservation in Universal DDI IPAM

    .PARAMETER Address
        The IP address for the new reservation

    .PARAMETER Name
        The name for the new reservation

    .PARAMETER Description
        The description of the new reservation

    .PARAMETER Space
        The IPAM space for the new reservation to be placed in

    .PARAMETER Tags
        Any tags you want to apply to the address reservation

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
        PS> New-B1AddressReservation -Address "10.0.0.1" -Name "MyReservedHost" -Description "My Reserved Host" -Space "Global"

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        IPAM
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Medium'
    )]
    param(
      [Parameter(Mandatory=$true)]
      [String]$Address,
      [Parameter(Mandatory=$false)]
      [String]$Name,
      [Parameter(Mandatory=$false)]
      [String]$Description,
      [Parameter(Mandatory=$true)]
      [String]$Space,
      [System.Object]$Tags,
      [Switch]$Force
    )
    $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
    if (!(Get-B1Address -Address $Address -Reserved)) {
        $splat = @{
	        "space" = (Get-B1Space -Name $Space -Strict).id
	        "address" = $Address
	        "comment" = $Description
	        "names" = @(@{
			        "name" = $Name
			        "type" = "user"
	        })
            "tags" = $Tags
        }
        $splat = ConvertTo-Json($splat) -Depth 2

        if($PSCmdlet.ShouldProcess("Create new Address Reservation:`n$($splat)","Create new Address Reservation: $($Name)",$MyInvocation.MyCommand)){
            $Result = Invoke-CSP -Method "POST" -Uri "$(Get-B1CSPUrl)/api/ddi/v1/ipam/address" -Data $splat
            if (($Result | Select-Object -ExpandProperty result).address -eq $Address) {
                Write-Host "Address Reservation created successfully." -ForegroundColor Green
                return $Result | Select-Object -ExpandProperty result
            } else {
                Write-Host "Error. Failed to create Address Reservation $Subnet." -ForegroundColor Red
                break
            }
        }
    } else {
        Write-Host "Address already exists." -ForegroundColor Red
    }
}