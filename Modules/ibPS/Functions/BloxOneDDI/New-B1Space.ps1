﻿function New-B1Space {
    <#
    .SYNOPSIS
        Creates a new BloxOneDDI IPAM/DHCP Space

    .DESCRIPTION
        This function is used to create a new BloxOneDDI IPAM/DHCP Space

    .PARAMETER Name
        The name of the IP Space

    .PARAMETER Description
        The description of the IP Space you are creating

    .PARAMETER Tags
        Any tags you want to apply to the new IP Space

    .EXAMPLE
        New-B1Space -Name "Global"
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        IPAM

    .FUNCTIONALITY
        DHCP
    #>
    param(
      [Parameter(Mandatory=$true)]
      [String]$Name,
      [Parameter(Mandatory=$true)]
      [String]$Description,
      [System.Object]$DHCPOptions,
      [String]$DDNSDomain,
      [System.Object]$Tags
    )
    $B1Space = Get-B1Space -Name $Name 6> $null
    if ($B1Space) {
        Write-Error "IP Space already exists with the name: $($Name)"
    } else {
        Write-Host "Creating IP Space..." -ForegroundColor Gray

        $splat = @{
            "name" = $Name
            "comment" = $Description
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
        if ($Debug) {$splat}

        $Result = Query-CSP -Method POST -Uri "ipam/ip_space" -Data $splat
        
        if (($Result | Select-Object -ExpandProperty result).name -eq $Name) {
            Write-Host "IP Space $($Name) created successfully." -ForegroundColor Green
            return $Result | Select-Object -ExpandProperty result
        } else {
            Write-Host "Failed to create IP Space $($Name)." -ForegroundColor Red
            break
        }
    }
}