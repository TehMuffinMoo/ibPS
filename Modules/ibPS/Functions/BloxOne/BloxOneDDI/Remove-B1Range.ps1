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

    .PARAMETER id
        The id of the range. Accepts pipeline input

    .EXAMPLE
        PS> Remove-B1Range -StartAddress "10.250.20.20" -EndAddress "10.250.20.100" -Space "Global"
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        IPAM
    
    .FUNCTIONALITY
        DHCP
    #>
    param(
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [String]$StartAddress,
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [String]$EndAddress,
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
        $B1Range = Get-B1Range -id $id
      } else {
        $B1Range = Get-B1Range -StartAddress $StartAddress -EndAddress $EndAddress -Space $Space
      }

      if (($B1Range | measure).Count -gt 1) {
        Write-Host "More than one DHCP Ranges returned. These will not be removed. To remove multiple objects, please pipe Get-B1Range into Remove-B1Range." -ForegroundColor Red
        $B1Range | Format-Table comment,start,end,space,name -AutoSize
      } elseif (($B1Range | measure).Count -eq 1) {
        Write-Host "Removing DHCP Range: $($B1Range.start) - $($B1Range.end).." -ForegroundColor Yellow
        $Result = Invoke-CSP -Method "DELETE" -Uri $($B1Range.id)
        $B1R = Get-B1Range -id $($B1Range.id)
        if ($B1R) {
          Write-Host "Error. Failed to remove DHCP Range: $($B1R.start) - $($B1R.end)" -ForegroundColor Red
        } else {
          Write-Host "Successfully removed DHCP Range: $($B1Range.start) - $($B1Range.end)" -ForegroundColor Green
        }
      } else {
        Write-Host "DHCP Range does not exist: $StartAddress$id" -ForegroundColor Gray
      }
    }
}