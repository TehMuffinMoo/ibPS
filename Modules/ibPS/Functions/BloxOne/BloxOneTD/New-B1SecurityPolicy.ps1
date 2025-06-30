function New-B1SecurityPolicy {
    <#
    .SYNOPSIS
        Creates a new Security Policy in Infoblox Threat Defense

    .DESCRIPTION
        This function is used to create a new Security Policy in Infoblox Threat Defense.

    .PARAMETER Name
        The name of the new Security Policy.

    .PARAMETER Description
        The description for the new Security Policy.

    .PARAMETER Precedence
        The precedence for the new Security Policy.

    .PARAMETER GeoLocation
        Set the Geolocation option to Enabled/Disabled. (Defaults to Disabled)

    .PARAMETER SafeSearch
        Set the Safe Search option to Enabled/Disabled. (Defaults to Disabled)

    .PARAMETER DoHPerPolicy
        Set the DoH Per Policy option to Enabled/Disabled. (Defaults to Disabled)

    .PARAMETER BlockDNSRebinding
        Set the Block DNS Rebinding Attacks option to Enabled/Disabled. (Defaults to Disabled)

    .PARAMETER LocalOnPremResolution
        Set the Local On-Prem Resolution option to Enabled/Disabled. (Defaults to Disabled)

    .PARAMETER DFPs
        A list of DNS Forwarding Proxy names to apply to the network scope. You can get a list of DFPs using Get-B1Service -Type DFP.

    .PARAMETER ExternalNetworks
        A list of External Network names to apply to the network scope. You can get a list of External Networks using Get-B1NetworkList.

    .PARAMETER IPAMNetworks
        A list of Address Blocks / Subnets / Ranges to apply to the network scope. You can build this list of networks using New-B1SecurityPolicyIPAMNetwork, see the examples.

    .PARAMETER Rules
        A list of Policy Rules to apply to the new Security Policy. You can build this list of rules using New-B1SecurityPolicyRule, see the examples.

    .PARAMETER Tags
        A list of tags to add to the new Security Policy

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
        $PolicyRules = @()
        $PolicyRules += New-B1SecurityPolicyRule -Action Allow -Type Category -Object All-Categories
        $PolicyRules += New-B1SecurityPolicyRule -Action Block -Type Feed -Object antimalware
        $PolicyRules += New-B1SecurityPolicyRule -Action Block -Type Custom -Object 'Threat Insight - Zero Day DNS'

        $IPAMNetworks = @()
        $IPAMNetworks += Get-B1Subnet 10.10.0.0/16 -Space 'My IP Space' | New-B1SecurityPolicyIPAMNetwork
        $IPAMNetworks += Get-B1Subnet 10.15.0.0/16 -Space 'My IP Space' | New-B1SecurityPolicyIPAMNetwork

        New-B1SecurityPolicy -Name 'My Policy' -Description 'My Policy' `
                             -DoHPerPolicy Enabled -GeoLocation Enabled `
                             -BlockDNSRebinding Enabled -DFPs 'B1-DFP-01','B1-DFP-02' `
                             -ExternalNetworks 'My External Network List' -Rules $PolicyRules `
                             -IPAMNetworks $IPAMNetworks

        access_codes            : {}
        block_dns_rebind_attack : True
        created_time            : 6/3/2024 10:24:47 AM
        default_action          : action_allow
        default_redirect_name   :
        description             : My Policy
        dfp_services            : {cv4g9f4jg98jg854jt5g,v4m38jg983egjh9cff}
        dfps                    : {123456,654321}
        doh_enabled             : True
        doh_fqdn                : dfsdgghhdh-btrb-4bbb-bffb-cmjumbfgfnhm9.doh.threatdefense.infoblox.com
        ecs                     : True
        id                      : 123456
        is_default              : False
        name                    : My Policy
        net_address_dfps        : {@{addr_net=10.10.0.0/16; dfp_ids=System.Object[]; dfp_service_ids=System.Object[]; end=10.10.255.255; external_scope_id=vsdvreg-bdrv-regb-g455-g5h5dhy54g5h; host_id=; ip_space_id=cdafsffc-fgfg-1fff-gh6v-j7iiku8idssdswzx; scope_type=SUBNET; start=10.10.0.0},
                                  @{addr_net=10.15.0.0/16; dfp_ids=System.Object[]; dfp_service_ids=System.Object[]; end=10.15.255.255; external_scope_id=gr8g5455-g45t-rg5r-g4g4-g4g4tdrehg; host_id=; ip_space_id=cdafsffc-fgfg-1fff-gh6v-j7iiku8idssdswzx; scope_type=SUBNET; start=10.15.0.0}}
        network_lists           : {789456}
        onprem_resolve          : False
        precedence              : 12
        roaming_device_groups   : {}
        rules                   : {@{action=action_allow; data=All-Categories; type=category_filter}, @{action=action_block; data=Threat Insight - Zero Day DNS; description=Auto-generated; type=custom_list}, @{action=action_block; data=antimalware; description=Suspicious/malicious as destinations:
                                Enables protection against known malicious hostname threats that can take action on or control of your systems, such as Malware Command & Control, Malware Download, and active Phishing sites.; type=named_feed}}
        safe_search             : False
        scope_expr              :
        scope_tags              : {}
        tags                    :
        updated_time            : 6/3/2024 10:24:47 AM
        user_groups             : {}

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Threat Defense
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Medium'
    )]
    param(
      [Parameter(Mandatory=$true)]
      [String]$Name,
      [String]$Description,
      [Int]$Precedence,
      [ValidateSet('Enabled','Disabled')]
      [String]$GeoLocation,
      [ValidateSet('Enabled','Disabled')]
      [String]$SafeSearch,
      [ValidateSet('Enabled','Disabled')]
      [String]$DoHPerPolicy,
      [ValidateSet('Enabled','Disabled')]
      [String]$BlockDNSRebinding,
      [ValidateSet('Enabled','Disabled')]
      [String]$LocalOnPremResolution,
      [String[]]$DFPs,
      [String[]]$ExternalNetworks,
      [System.Object]$IPAMNetworks,
      [System.Object]$Rules,
      [System.Object]$Tags,
      [Switch]$Force
    )

    process {
        $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
        $Splat = @{
            "name" = $($Name)
            "description" = $($Description)
            "precedence" = $Precedence
            "ecs" = $(if ($GeoLocation -eq 'Enabled') { $true } else { $false })
            "safe_search" = $(if ($SafeSearch -eq 'Enabled') { $true } else { $false })
            "doh_enabled" = $(if ($DoHPerPolicy -eq 'Enabled') { $true } else { $false })
            "block_dns_rebind_attack" = $(if ($BlockDNSRebinding -eq 'Enabled') { $true } else { $false })
            "onprem_resolve" = $(if ($LocalOnPremResolution -eq 'Enabled') { $true } else { $false })
            "tags" = $($Tags)
            "dfp_services" = @()
            "network_lists" = @()
            "rules" = @()
            "net_address_dfps" = @()
        }
        if ($Splat.doh_enabled) {
            $Splat.doh_fqdn = (New-B1DoHFQDN).doh_fqdn
        }

        if ($DFPs) {
            $DFPs | ForEach-Object {
                $DFPService = Get-B1Service -Type dfp -Name $_ -Detailed -Strict
                if ($DFPService) {
                    $Splat.dfp_services += $DFPService.id
                } else {
                    Write-Error "Unable to find DNS Forwarding Proxy: $($_)"
                    return $null
                }
            }
        }

        if ($ExternalNetworks) {
            $ExternalNetworks | ForEach-Object {
                $ExternalNetwork = Get-B1NetworkList -Name $_ -Strict
                if ($ExternalNetwork) {
                    $Splat.network_lists += $ExternalNetwork.id
                } else {
                    Write-Error "Unable to find External Network: $($_)"
                    return $null
                }
            }
        }

        if ($IPAMNetworks) {
            $Splat.net_address_dfps = @($IPAMNetworks)
        }

        if ($Rules) {
            $Splat.rules = $Rules
        }

        $JSON = $Splat | ConvertTo-Json -Depth 5

        if($PSCmdlet.ShouldProcess("Create new Security Policy:`n$($JSON)","Create new Security Policy: $($Name)",$MyInvocation.MyCommand)){
            $Result = Invoke-CSP -Method POST -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/security_policies" -Data $JSON | Select-Object -ExpandProperty results -EA SilentlyContinue -WA SilentlyContinue
            if ($Result.name -eq $Name) {
                return $Result
            } else {
                Write-Host "Failed to create Security Policy: $Name." -ForegroundColor Red
                break
            }
        }
    }
}