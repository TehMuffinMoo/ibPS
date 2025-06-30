function New-B1DHCPConfigProfile {
    <#
    .SYNOPSIS
        Creates a new DHCP Config Profile in BloxOneDDI

    .DESCRIPTION
        This function is used to create a new DHCP Config Profile in BloxOneDDI

    .PARAMETER Name
        The name of the new DHCP Config Profile

    .PARAMETER Description
        The description of the new DHCP Config Profile

    .PARAMETER DHCPOptions
        A list of DHCP Options you want to apply to the new DHCP Config Profile.

    .PARAMETER DDNSDomain
        Optionally specify a DDNS Domain for the DHCP Config Profile

    .PARAMETER DDNSZones
        A list of DDNS Zones to apply to this DHCP Config Profile

    .PARAMETER Tags
        Any tags you want to apply to the new DHCP Config Profile

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
        PS> $DHCPOptions = @()
        PS> $DHCPOptions += @{"type"="option";"option_code"=(Get-B1DHCPOptionCode -Name "routers").id;"option_value"="10.10.100.1";}

        PS> New-B1DHCPConfigProfile -Name "Profile Name" -Description "Profile Description" -DHCPOptions $DHCPOptions -DDNSZones "prod.mydomain.corp","100.10.in-addr.arpa"

    .FUNCTIONALITY
        Universal DDI
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Medium'
    )]
    param(
      [Parameter(Mandatory=$true)]
      [String]$Name,
      [String]$Description,
      [System.Object]$DHCPOptions = @(),
      [String]$DDNSDomain,
      [System.Object]$DDNSZones,
      [System.Object]$Tags,
      [Switch]$Force
    )
    $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
    $ConfigProfile = Get-B1DHCPConfigProfile -Name $Name -Strict -IncludeInheritance
    if ($ConfigProfile) {
        Write-Host "The DHCP Config Profile: $Name already exists." -ForegroundColor Yellow
    } else {
        $splat = @{
            "name" = $Name
            "comment" = $Description
            "dhcp_options" = $DHCPOptions
            "dhcp_options_v6" = @()
            "inheritance_sources" = @{
                "dhcp_options" = @{
	                "action" = "inherit"
	                "value" = @()
                }
                "dhcp_options_v6" = @{
	                "action" = "inherit"
	                "value" = @()
                }
                "ddns_block" = @{
	                "action" = "override"
                }
                "ddns_hostname_block" = @{
	                "action" = "inherit"
                }
                "ddns_update_on_renew" = @{
	                "action" = "inherit"
                }
                "ddns_conflict_resolution_mode" = @{
	                "action" = "inherit"
                }
                "ddns_client_update" = @{
	                "action" = "inherit"
                }
                "hostname_rewrite_block" = @{
	                "action" = "inherit"
                }
            }
        }

        if ($DDNSZones) {
            $splat.inheritance_sources.ddns_block.action = "override"
	        $splat.dhcp_config = @{}
	        $splat.ddns_enabled = $true
	        $splat.ddns_send_updates = $true

            $ConfigProfileJson = @()
            foreach ($DDNSZone in $DDNSZones) {
                $DDNSZone = $DDNSZone.TrimEnd(".")
                $AuthZone = Get-B1AuthoritativeZone -FQDN $DDNSZone -View $DNSView -Strict
                if ($AuthZone) {
                    $AuthZoneSplat = @{
                        "zone" = $AuthZone.id
                    }
                    $AuthZoneSplat = $AuthZoneSplat | ConvertTo-Json | ConvertFrom-Json
                    $ConfigProfileJson += $AuthZoneSplat
                } else {
                    Write-Error "Error: Authoritative Zone: $($DDNSZone) not found."
                    return $null
                }
                $ToUpdate += $DDNSZone
            }
	        $splat.ddns_zones = $ConfigProfileJson
        }

        if ($Tags) {
            $splat | Add-Member -MemberType NoteProperty -Name "tags" -Value $Tags
        }

        if ($DDNSDomain) {
            $splat.ddns_domain = $DDNSDomain
        }

        $splat = $splat | ConvertTo-Json -Depth 4

        if($PSCmdlet.ShouldProcess("Create new DHCP Config Profile:`n$($splat)","Create new DHCP Config Profile: $($Name)",$MyInvocation.MyCommand)){
            Write-Host "Creating DHCP Config Profile: $Name..." -ForegroundColor Gray
            $Result = Invoke-CSP -Method POST -Uri "$(Get-B1CSPUrl)/api/ddi/v1/dhcp/server" -Data $splat | Select-Object -ExpandProperty result

            if ($($Result).name -eq $Name) {
                Write-Host "DHCP Config Profile: $Name created successfully." -ForegroundColor Green
                return $Result
            } else {
                Write-Host "Failed to create DHCP Config Profile: $Name" -ForegroundColor Red
                break
            }
        }
    }
}