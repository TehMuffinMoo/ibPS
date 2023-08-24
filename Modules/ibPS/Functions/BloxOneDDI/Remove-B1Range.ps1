function Remove-B1Range {
    <#
    .SYNOPSIS
        Removes a DHCP Range from BloxOneDDI

    .DESCRIPTION
        This function is used to remove a DHCP Range from BloxOneDDI

    .PARAMETER StartAddress
        The start address of the DHCP Range

    .PARAMETER EndAddress
        The end address of the DHCP Range

    .PARAMETER Space
        Use this parameter to filter the list of Address Blocks by Space

    .Example
        Remove-B1Range -Start "10.250.20.20" -End "10.250.20.100" -Space "Global"
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        IPAM
    
    .FUNCTIONALITY
        DHCP
    #>
    param(
      [Parameter(Mandatory=$true)]
      [String]$StartAddress,
      [Parameter(Mandatory=$true)]
      [String]$EndAddress,
      [Parameter(Mandatory=$true)]
      [String]$Space
    )
    
    $B1Range = Get-B1Range -StartAddress $StartAddress -EndAddress $EndAddress -Space $Space

    if (($B1Range | measure).Count -gt 1) {
        Write-Host "More than one DHCP Ranges returned. These will not be removed." -ForegroundColor Red
        $B1Range | ft comment,start,end,space,name -AutoSize
    } elseif (($B1Range | measure).Count -eq 1) {
        Write-Host "Removing DHCP Range: $($B1Range.start) - $($B1Range.end).." -ForegroundColor Yellow
        $Result = Query-CSP -Method "DELETE" -Uri $B1Range.id
        if (Get-B1Range -StartAddress $StartAddress -EndAddress $EndAddress) {
            Write-Host "Error. Failed to remove DHCP Range: $($B1Range.start) - $($B1Range.end)" -ForegroundColor Red
        } else {
            Write-Host "Successfully removed DHCP Range: $($B1Range.start) - $($B1Range.end)" -ForegroundColor Green
        }
    } else {
        Write-Host "DHCP Range does not exist: $($B1Range.start) - $($B1Range.end)" -ForegroundColor Gray
    }
}