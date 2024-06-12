function New-B1Space {
    <#
    .SYNOPSIS
        Creates a new BloxOneDDI IPAM/DHCP Space

    .DESCRIPTION
        This function is used to create a new BloxOneDDI IPAM/DHCP Space

    .PARAMETER Name
        The name of the IP Space

    .PARAMETER Description
        The description of the IP Space you are creating

    .PARAMETER DHCPOptions
        A list of DHCP Options you want to apply to the new IP Space. These will be inherited by any child Address Blocks, Subnets & Ranges.

    .PARAMETER DDNSDomain
        The DDNS Domain to apply to the new IP Space. This will be inherited by any child Address Blocks, Subnets & Ranges.

    .PARAMETER Compartment
        The name of the compartment to assign to this space

    .PARAMETER Tags
        Any tags you want to apply to the new IP Space

    .EXAMPLE
        PS> New-B1Space -Name "Global"
    
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
      [String]$Description,
      [System.Object]$DHCPOptions,
      [String]$DDNSDomain,
      [String]$Compartment,
      [System.Object]$Tags
    )
    $B1Space = Get-B1Space -Name $Name -Strict 6> $null
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

        if ($Compartment) {
            $CompartmentID = (Get-B1Compartment -Name $Compartment -Strict).id
            if (!($CompartmentID)) {
                Write-Error "Unable to find compartment with name: $($Compartment)"
                return $null
            } else {
                $splat.compartment_id = $CompartmentID
            }
        }

        if ($Tags) {
            $splat | Add-Member -MemberType NoteProperty -Name "tags" -Value $Tags
        }

        $splat = $splat | ConvertTo-Json -Depth 4 -Compress

        $Result = Invoke-CSP -Method POST -Uri "ipam/ip_space" -Data $splat | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
        
        if ($Result.name -eq $Name) {
            Write-Host "IP Space $($Name) created successfully." -ForegroundColor Green
            return $Result
        } else {
            Write-Host "Failed to create IP Space $($Name)." -ForegroundColor Red
            break
        }
    }
}