function New-B1AddressBlock {
    <#
    .SYNOPSIS
        Creates a new address block in BloxOneDDI IPAM

    .DESCRIPTION
        This function is used to create a new address block in BloxOneDDI IPAM

    .PARAMETER Subnet
        The network address of the address block you want to create

    .PARAMETER CIDR
        The CIDR suffix of the address block you want to create

    .PARAMETER Space
        The IPAM space for the address block to be placed in

    .PARAMETER Name
        The name of the address block you want to create

    .PARAMETER Description
        The description of the address block you want to create

    .PARAMETER DHCPOptions
        A list of DHCP Options you want to apply to the new address block.
        
    .PARAMETER DDNSDomain
        The DDNS Domain to apply to the new address block

    .PARAMETER Tags
        Any tags you want to apply to the address block

    .EXAMPLE
        ##Example usage when combined with Get-B1DHCPOptionCode
        $DHCPOptions = @()
        $DHCPOptions += @{"type"="option";"option_code"=(Get-B1DHCPOptionCode -Name "routers").id;"option_value"="10.10.100.1";}
        
        PS> New-B1AddressBlock -Subnet "10.30.0.0" -CIDR "20" -Space "Global" -Name "My Subnet" -Description "My Production Subnet" -DHCPOptions $DHCPOptions
    
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
      [Parameter(Mandatory=$true)]
      [String]$Name,
      [String]$Description,
      [System.Object]$DHCPOptions,
      [String]$DDNSDomain,
      [System.Object]$Tags
      )

    $SpaceUUID = (Get-B1Space -Name $Space -Strict).id

    if (Get-B1AddressBlock -Subnet $Subnet -Space $Space -CIDR $CIDR) {
        Write-Host "The Address Block $Subnet/$CIDR already exists." -ForegroundColor Yellow
    } else {
        Write-Host "Creating Address Block $Subnet/$CIDR..." -ForegroundColor Gray

        $splat = @{
            "space" = $SpaceUUID
            "address" = $Subnet
            "cidr" = $CIDR
            "comment" = $Description
            "name" = $Name
            "dhcp_options" = $DHCPOptions
        }

        if ($DDNSDomain) {
            $splat."ddns_domain" = $DDNSDomain
            $DDNSupdateBlock = @{
                ddns_update_block = @{
			        "action" = "override"
			        "value" = @{}
		        }
            }
            $splat.inheritance_sources = $DDNSupdateBlock
        }

        if ($Tags) {
            $splat | Add-Member -MemberType NoteProperty -Name "tags" -Value $Tags
        }

        $splat = $splat | ConvertTo-Json -Depth 4

        $Result = Invoke-CSP -Method POST -Uri "ipam/address_block" -Data $splat | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue
        
        if ($Result.address -eq $Subnet) {
            Write-Host "Address Block $Subnet/$CIDR created successfully." -ForegroundColor Green
            return $Result
        } else {
            Write-Host "Failed to create Address Block $Subnet." -ForegroundColor Red
            break
        }
    }
}