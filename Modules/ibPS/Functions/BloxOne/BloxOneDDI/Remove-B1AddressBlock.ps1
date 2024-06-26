﻿function Remove-B1AddressBlock {
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

    .PARAMETER id
        The id of the address block. Accepts pipeline input

    .EXAMPLE
        PS> Remove-B1AddressBlock -Subnet "10.0.0.1" -CIDR "24" -Space "Global"
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        IPAM
    #>
    param(
      [Parameter(
        ParameterSetName="Default",
        Mandatory=$true
      )]
      [String]$Subnet,
      [Parameter(
        ParameterSetName="Default",
        Mandatory=$true
      )]
      [ValidateRange(0,32)]
      [Int]$CIDR,
      [Parameter(
        ParameterSetName="Default",
        Mandatory=$true
      )]
      [String]$Space,
      [Switch]$Recurse,
      [Switch]$NoWarning,
      [Parameter(
        ValueFromPipelineByPropertyName = $true,
        ParameterSetName="With ID",
        Mandatory=$true
      )]
      [String]$id
    )

    process {
      if ($id) {
        $AddressBlock = Get-B1AddressBlock -id $id
      } else {
        $AddressBlock = Get-B1AddressBlock -Subnet $Subnet -CIDR $CIDR -Space $Space
      }
  
      if ($Recurse -and -not $NoWarning) {
          Write-Warning "WARNING! -Recurse will remove all child objects that exist within the Address Block: $Subnet/$CIDR. Are you sure you want to do this?" -WarningAction Inquire
          $URI = "$($AddressBlock.id)?_options=recurse=true"
      } else {
          $URI = $AddressBlock.id
      }
  
      if (($AddressBlock | measure).Count -gt 1) {
          Write-Host "More than one address block returned. These will not be removed." -ForegroundColor Red
          $AddressBlock | Format-Table -AutoSize
      } elseif (($AddressBlock | measure).Count -eq 1) {
          Write-Host "Removing Address Block: $($AddressBlock.Address)/$($AddressBlock.cidr).." -ForegroundColor Yellow
          Invoke-CSP -Method "DELETE" -Uri $URI | Out-Null
          $AB = Get-B1AddressBlock -id $($AddressBlock.id)
          if ($AB) {
            Write-Host "Failed to remove Address Block: $($AB.Address)/$($AB.cidr)" -ForegroundColor Red
          } else {
            Write-Host "Successfully removed Address Block: $($AddressBlock.Address)/$($AddressBlock.cidr)" -ForegroundColor Green
          }
      } else {
          Write-Host "Address Block does not exist: $($AddressBlock.Address)/$($AddressBlock.cidr)" -ForegroundColor Gray
      }
    }
}