﻿function New-B1Subnet {
    <#
    .SYNOPSIS
        Creates a new subnet in Universal DDI IPAM

    .DESCRIPTION
        This function is used to create a new subnet in Universal DDI IPAM

    .PARAMETER Subnet
        The network address of the subnet you want to create

    .PARAMETER CIDR
        The CIDR suffix of the subnet you want to create

    .PARAMETER Space
        The IPAM space for the subnet to be placed in

    .PARAMETER Name
        The name of the subnet you want to create

    .PARAMETER Description
        The description of the subnet you want to create

    .PARAMETER HAGroup
        The name of the HA group to apply to this subnet

    .PARAMETER DHCPOptions
        A list of DHCP Options you want to apply to the new subnet.

    .PARAMETER DDNSDomain
        The DDNS Domain to apply to the new subnet

    .PARAMETER Tags
        Any tags you want to apply to the subnet

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
        PS> New-B1Subnet -Subnet "10.30.5.0" -CIDR "24" -Space "Global" -Name "My Subnet" -Description "My Production Subnet"

    .EXAMPLE
        ## Example showing building DHCP options using Get-B1DHCPOptionCode
        $DHCPOptions = @()
        $DHCPOptions += @{"type"="option";"option_code"=(Get-B1DHCPOptionCode -Name "routers").id;"option_value"="10.10.100.1";}

        PS> New-B1Subnet -Subnet "10.30.5.0" -CIDR "24" -Space "Global" -Name "My Subnet" -Description "My Production Subnet" -DHCPOptions $DHCPOptions

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
      [String]$Name,
      [System.Object]$HAGroup,
      [String]$Description,
      [System.Object]$DHCPOptions,
      [String]$DDNSDomain,
      [System.Object]$Tags,
      [Switch]$Force
    )
    $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
    $SpaceUUID = (Get-B1Space -Name $Space -Strict).id
    if ($HAGroup) {
        $DHCPHost = (Get-B1HAGroup -Name $HAGroup).id
    }

    if (Get-B1Subnet -Subnet $Subnet -Space $Space -CIDR $CIDR) {
        Write-Host "The subnet $Subnet/$CIDR already exists." -ForegroundColor Yellow
    } else {
        $splat = @{
            "space" = $SpaceUUID
            "address" = $Subnet
            "cidr" = $CIDR
            "comment" = $Description
            "name" = $Name
            "dhcp_host" = $DHCPHost
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

        $splat = $splat | ConvertTo-Json -Depth 4
        if($PSCmdlet.ShouldProcess("Create new Subnet:`n$($splat)","Create new Subnet: $($Subnet)/$($CIDR)",$MyInvocation.MyCommand)){
            Write-Host "Creating subnet..." -ForegroundColor Gray
            $Result = Invoke-CSP -Method POST -Uri "$(Get-B1CSPUrl)/api/ddi/v1/ipam/subnet" -Data $splat | Select-Object -ExpandProperty result -EA SilentlyContinue -WA SilentlyContinue
            if ($Result.address -eq $Subnet) {
                Write-Host "Subnet $Subnet/$CIDR created successfully." -ForegroundColor Green
                return $Result
            } else {
                Write-Host "Failed to create subnet $Subnet/$CIDR." -ForegroundColor Red
                break
            }
        }
    }
}