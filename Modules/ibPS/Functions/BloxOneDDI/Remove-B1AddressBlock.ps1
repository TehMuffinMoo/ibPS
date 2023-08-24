function Remove-B1AddressBlock {
    <#
    .SYNOPSIS
        Removes an address block from BloxOneDDI IPAM

    .DESCRIPTION
        This function is used to remove an address block from BloxOneDDI IPAM

    .PARAMETER Subnet
        The network address of the address block you want to remove

    .PARAMETER CIDR
        The CIDR suffix of the address block you want to remove

    .PARAMETER Space
        The IPAM space where the address block is located

    .PARAMETER Recurse
        WARNING! Using -Recurse will move all child objects to the recycle bin. By default, child objects are re-parented.

    .PARAMETER NoWarning
        WARNING! This is very dangerous if used inappropriately.
        The -NoWarning parameter is there to be combined with -Recurse. When specified, using -Recurse will not prompt for confirmation before deleting.

    .Example
        Remove-B1AddressBlock -Subnet "10.0.0.1" -CIDR "24" -Space "Global"
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        IPAM
    #>
    param(
      [Parameter(Mandatory=$true)]
      [String]$Subnet,
      [Parameter(Mandatory=$true)]
      [ValidateRange(0,32)]
      [Int]$CIDR,
      [Parameter(Mandatory=$true)]
      [String]$Space,
      [Switch]$Recurse,
      [Switch]$NoWarning
    )
        
    $AddressBlock = Get-B1AddressBlock -Subnet $Subnet -CIDR $CIDR -Space $Space

    if ($Recurse -and -not $NoWarning) {
        Write-Warning "WARNING! -Recurse will remove all child objects that exist within the Address Block: $Subnet/$CIDR. Are you sure you want to do this?" -WarningAction Inquire
        $URI = "$($AddressBlock.id)?_options=recurse=true"
    } else {
        $URI = $AddressBlock.id
    }

    if (($AddressBlock | measure).Count -gt 1) {
        Write-Host "More than one address block returned. These will not be removed." -ForegroundColor Red
        $AddressBlock | ft -AutoSize
    } elseif (($AddressBlock | measure).Count -eq 1) {
        Write-Host "Removing Address Block: $($AddressBlock.Address)/$($AddressBlock.cidr).." -ForegroundColor Yellow
        $Result = Query-CSP -Method "DELETE" -Uri $URI
        if (Get-B1AddressBlock -Subnet $Subnet -CIDR $CIDR -Space $Space) {
            Write-Host "Failed to remove Address Block: $($AddressBlock.Address)/$($AddressBlock.cidr)" -ForegroundColor Red
        } else {
            Write-Host "Successfully removed Address Block: $($AddressBlock.Address)/$($AddressBlock.cidr)" -ForegroundColor Green
        }
    } else {
        Write-Host "Address Block does not exist: $($AddressBlock.Address)/$($AddressBlock.cidr)" -ForegroundColor Gray
    }
}