﻿function New-B1AddressBlock {
    <#
    .SYNOPSIS
        Creates a new address block in Universal DDI IPAM

    .DESCRIPTION
        This function is used to create a new address block in Universal DDI IPAM

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

    .PARAMETER Compartment
        The name of the compartment to assign to this address block

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .PARAMETER Tags
        Any tags you want to apply to the address block

    .EXAMPLE
        ##Example usage when combined with Get-B1DHCPOptionCode
        $DHCPOptions = @()
        $DHCPOptions += @{"type"="option";"option_code"=(Get-B1DHCPOptionCode -Name "routers").id;"option_value"="10.10.100.1";}

        PS> New-B1AddressBlock -Subnet "10.30.0.0" -CIDR "20" -Space "Global" -Name "My Subnet" -Description "My Production Subnet" -DHCPOptions $DHCPOptions

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
      [String]$Compartment,
      [System.Object]$Tags,
      [Switch]$Force
    )
    $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
    $SpaceUUID = (Get-B1Space -Name $Space -Strict).id

    if (Get-B1AddressBlock -Subnet $Subnet -Space $Space -CIDR $CIDR) {
        Write-Host "The Address Block $Subnet/$CIDR already exists." -ForegroundColor Yellow
    } else {
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
            $splat.tags = $Tags
        }
        if ($Compartment) {
            $CompartmentID = (Get-B1Compartment -Name $Compartment -Strict).id
            if (!($CompartmentID)) {
                Write-Error "Unable to find compartment with name: $($Compartment)"
                return $null
            } else {
                $splat.compartment_id = $CompartmentID
            }
        }

        $splat = $splat | ConvertTo-Json -Depth 4

        if($PSCmdlet.ShouldProcess("Create new Address Block:`n$($splat)","Create new Address Block: $($Name)",$MyInvocation.MyCommand)){
            Write-Host "Creating Address Block $Subnet/$CIDR..." -ForegroundColor Gray
            $Result = Invoke-CSP -Method POST -Uri "$(Get-B1CSPUrl)/api/ddi/v1/ipam/address_block" -Data $splat | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue
            if ($Result.address -eq $Subnet) {
                Write-Host "Address Block $Subnet/$CIDR created successfully." -ForegroundColor Green
                return $Result
            } else {
                Write-Host "Failed to create Address Block $Subnet." -ForegroundColor Red
                break
            }
        }
    }
}