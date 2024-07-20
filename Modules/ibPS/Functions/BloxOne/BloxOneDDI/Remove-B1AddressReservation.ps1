function Remove-B1AddressReservation {
    <#
    .SYNOPSIS
        Removes an address reservation from BloxOneDDI IPAM

    .DESCRIPTION
        This function is used to remove an address reservation from BloxOneDDI IPAM

    .PARAMETER Address
        The IP address of the reservation to remove

    .PARAMETER Object
        The Address Reservation Object to remove. Accepts pipeline input.

    .PARAMETER Space
        The IPAM space where the address reservation is located.

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

    .EXAMPLE
        PS> Remove-B1AddressReservation -Address "10.0.0.1" -Space "Global"

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        IPAM
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'High'
    )]
    param(
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [String]$Address,
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
            if (("$($SplitID[0])/$($SplitID[1])") -ne "ipam/address") {
                Write-Error "Error. Unsupported pipeline object. This function only supports 'ipam/address' objects as input"
                return $null
            }
            if ('IPAM RESERVED' -notin $Object.usage) {
                Write-Error "Error. Unsupported pipeline object. This function only supports address objects which are IPAM RESERVED."
                return $null
            }
        } else {
            $Object = Get-B1Address -Address $Address -Reserved -Space $Space
            if (!($Object)) {
                Write-Error "Unable to find Address Reservation: $($Address) in IP Space: $($Space)"
                return $null
            }
            if ($Object.count -gt 1) {
                Write-Error "Multiple Address Reservations were found, to remove more than one Address you should pass those objects using pipe instead."
                return $null
            }
        }
        if($PSCmdlet.ShouldProcess("$($Object.address) ($($Object.id))")){
            $null = Invoke-CSP -Method "DELETE" -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($Object.id)" | Out-Null
            $AR = Get-B1Address -id $($Object.id) -Reserved
            if (!($AR)) {
                Write-Host "Address Reservation deleted successfully: $($Object.address)." -ForegroundColor Green
            } else {
                Write-Host "Failed to delete Address Reservation: $($AR.address)" -ForegroundColor Red
                break
            }
        }
    }
}