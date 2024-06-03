function New-B1SecurityPolicy {
    <#
    .SYNOPSIS
        Creates a new Security Policy in BloxOne Threat Defense

    .DESCRIPTION
        This function is used to create a new Security Policy in BloxOne Threat Defense.

    .PARAMETER Name
        The name of the new Security Policy.

    .PARAMETER Description
        The description for the new Security Policy.

    .PARAMETER Precendence
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

    .PARAMETER Rules
        A list of Policy Rules to apply to the new Security Policy. You can build this list of rules using New-B1SecurityPolicyRule, see the examples.
        
    .PARAMETER Tags
        A list of tags to add to the new Security Policy

    .EXAMPLE
        $PolicyRules = @()
        $PolicyRules += New-B1SecurityPolicyRule -Action Allow -Type Category -Object All-Categories
        $PolicyRules += New-B1SecurityPolicyRule -Action Block -Type Feed -Object antimalware
        $PolicyRules += New-B1SecurityPolicyRule -Action Block -Type Custom -Object 'Threat Insight - Zero Day DNS'

        New-B1SecurityPolicy -Name 'My Policy' -Description 'My Policy' `
                             -DoHPerPolicy Enabled -GeoLocation Enabled `
                             -BlockDNSRebinding Enabled -DFPs 'B1-DFP-01','B1-DFP-02' `
                             -ExternalNetworks 'My External Network List' -Rules $PolicyRules

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
        net_address_dfps        : {}
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
      [System.Object]$Rules,
      [System.Object]$Tags
    )

    process {
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
        }
        if ($Splat.doh_enabled) {
            $Splat.doh_fqdn = (New-B1DoHFQDN).doh_fqdn
        }

        if ($DFPs) {
            $DFPs | %{
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
            $ExternalNetworks | %{
                $ExternalNetwork = Get-B1NetworkList -Name $_ -Strict
                if ($ExternalNetwork) {
                    $Splat.network_lists += $ExternalNetwork.id
                } else {
                    Write-Error "Unable to find External Network: $($_)"
                    return $null
                }
            }
        }

        if ($Rules) {
            $Splat.rules = $Rules
        }

        $JSON = $Splat | ConvertTo-Json -Depth 5

        $Result = Invoke-CSP -Method POST -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/security_policies" -Data $JSON | Select-Object -ExpandProperty results -EA SilentlyContinue -WA SilentlyContinue
        if ($Result.name -eq $Name) {
            return $Result
        } else {
            Write-Host "Failed to create Security Policy: $Name." -ForegroundColor Red
            break
        }

    }
}