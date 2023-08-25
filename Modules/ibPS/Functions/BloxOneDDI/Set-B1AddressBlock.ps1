function Set-B1AddressBlock {
    <#
    .SYNOPSIS
        Updates an existing address block in BloxOneDDI IPAM

    .DESCRIPTION
        This function is used to update an existing address block in BloxOneDDI IPAM

    .PARAMETER Subnet
        The network address of the address block you want to update

    .PARAMETER CIDR
        The CIDR suffix of the address block you want to update

    .PARAMETER Space
        The IPAM space where the address block is located

    .PARAMETER Name
        The new name for the address block

    .PARAMETER Description
        The new description for the address block

    .PARAMETER DHCPOptions
        A list of DHCP Options you want to update the address block with. This will overwrite existing options.
        
        Example usage when combined with Get-B1DHCPOptionCode

        $DHCPOptions = @()
        $DHCPOptions += @{"type"="option";"option_code"=(Get-B1DHCPOptionCode -Name "routers").id;"option_value"="10.10.100.1";}
        $DHCPOptions += @{"type"="option";"option_code"=(Get-B1DHCPOptionCode -Name "domain-name-servers").id;"option_value"="10.10.10.10,10.10.10.11";}

    .PARAMETER DDNSDomain
        The new DDNS Domain for the address block

    .PARAMETER DHCPLeaseSeconds
        The default DHCP Lease duration in seconds

    .PARAMETER Tags
        A list of tags to update on the address block. This will replace existing tags, so would normally be a combined list of existing and new tags

    .Example
        Set-B1AddressBlock -Subnet "10.10.100.0" -Name "Updated name" -Space "Global" -Description "Comment for description" -DHCPOptions $DHCPOptions
    
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
      [String]$Name,
      [System.Object]$DHCPOptions,
      [String]$Description,
      [String]$DHCPLeaseSeconds,
      [String]$DDNSDomain,
      [System.Object]$Tags
    )

    $AddressBlock = Get-B1AddressBlock -Subnet $Subnet -CIDR $CIDR -Space $Space -IncludeInheritance

    if ($AddressBlock) {
        $AddressBlockUri = $AddressBlock.id

        $AddressBlockPatch = @{}
        if ($Name) {$AddressBlockPatch.name = $Name}
        if ($Description) {$AddressBlockPatch.comment = $Description}
        if ($DHCPOptions) {$AddressBlockPatch.dhcp_options = $DHCPOptions}

        if ($DHCPLeaseSeconds) {
            $AddressBlock.inheritance_sources.dhcp_config.lease_time.action = "override"
            $AddressBlock.dhcp_config.lease_time = $DHCPLeaseSeconds

            $AddressBlockPatch.inheritance_sources = $AddressBlock.inheritance_sources
            $AddressBlockPatch.dhcp_config = $AddressBlock.dhcp_config
        }

        if ($DDNSDomain) {
            $AddressBlockPatch."ddns_domain" = $DDNSDomain
            $DDNSupdateBlock = @{
                ddns_update_block = @{
			        "action" = "override"
			        "value" = @{}
		        }
            }
            $AddressBlockPatch.inheritance_sources = $DDNSupdateBlock
        }

        if ($Tags) {
            $AddressBlockPatch.tags = $Tags
        }

        if ($AddressBlockPatch.Count -eq 0) {
            Write-Host "Nothing to update." -ForegroundColor Gray
        } else {
            $splat = $AddressBlockPatch | ConvertTo-Json -Depth 10
            if ($Debug) {$splat}

            $Result = Query-CSP -Method PATCH -Uri "$AddressBlockUri" -Data $splat
        
            if (($Result | select -ExpandProperty result).address -eq $Subnet) {
                Write-Host "Updated Address Block $Subnet/$($AddressBlock.cidr) successfully." -ForegroundColor Green
            } else {
                Write-Host "Failed to update Address Block $Subnet." -ForegroundColor Red
                break
            }
        }

    } else {
        Write-Host "The Address Block $Subnet/$CIDR does not exists." -ForegroundColor Red
    }
}