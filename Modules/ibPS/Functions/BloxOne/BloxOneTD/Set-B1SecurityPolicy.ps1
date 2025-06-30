function Set-B1SecurityPolicy {
    <#
    .SYNOPSIS
        Updates an existing Security Policy in Infoblox Threat Defense

    .DESCRIPTION
        This function is used to update an existing Security Policy in Infoblox Threat Defense.

    .PARAMETER Name
        The name of the new Security Policy.

    .PARAMETER NewName
        The new name to set the Security Policy to.

    .PARAMETER Description
        The new description for the Security Policy

    .PARAMETER Precedence
        The new precedence for the new Security Policy.

    .PARAMETER GeoLocation
        Enable or Disable the Geolocation option.

    .PARAMETER SafeSearch
        Enable or Disable the Safe Search option.

    .PARAMETER DoHPerPolicy
        Enable or Disable the DoH Per Policy option.

    .PARAMETER BlockDNSRebinding
        Enable or Disable the Block DNS Rebinding Attacks option.

    .PARAMETER LocalOnPremResolution
        Enable or Disable the Local On-Prem Resolution option.

    .PARAMETER DFPs
        A list of DNS Forwarding Proxy names to apply to the network scope. You can get a list of DFPs using Get-B1Service -Type DFP.

    .PARAMETER ExternalNetworks
        A list of External Network names to apply to the network scope. You can get a list of External Networks using Get-B1NetworkList.

    .PARAMETER IPAMNetworks
        A list of Address Blocks / Subnets / Ranges to apply to the network scope. You can build this list of networks using New-B1SecurityPolicyIPAMNetwork, see the examples.

    .PARAMETER Rules
        A list of Policy Rules to apply to the new Security Policy. You can build this list of rules using New-B1SecurityPolicyRule, see the examples.

    .PARAMETER Tags
        A list of tags to apply to the Security Policy

    .PARAMETER Object
        The Security Policy Object(s) to update. Accepts pipeline input.

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
        ## Example of copying rules from one Security Policy to another.

        $PolicyRules = (Get-B1SecurityPolicy -Name 'Main Policy').rules
        Get-B1SecurityPolicy -Name 'Child Policy' | Set-B1SecurityPolicy -Rules $PolicyRules

    .EXAMPLE
        Get-B1SecurityPolicy -Name 'My Policy' | Set-B1SecurityPolicy -Precedence 5 -LocalOnPremResolution Enabled

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
        onprem_resolve          : True
        precedence              : 5
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
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [String]$Name,
      [String]$NewName,
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
      [Parameter(
        ValueFromPipeline = $true,
        ParameterSetName="Pipeline",
        Mandatory=$true
      )]
      [System.Object]$Object,
      [Switch]$Force
    )

    process {
        $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
        if ($Object) {
            if ('onprem_resolve' -notin $Object.PSObject.Properties.Name) {
                Write-Error "Unsupported pipeline object. This function only supports Security Policy objects as input. (Get-B1SecurityPolicy)"
                return $null
            }
        } else {
            $Object = Get-B1SecurityPolicy -Name $Name -Strict
            if (!($Object)) {
                Write-Error "Unable to find Security Policy with name: $($Name)"
            }
        }

        $NewObj = $Object | Select-Object * -ExcludeProperty id,created_time,updated_time

        if ($NewName) {
            $NewObj.name = $Name
        }
        if ($Description) {
            $NewObj.description = $Description
        }
        if ($Precedence) {
            $NewObj.precedence = $Precedence
        }
        if ($GeoLocation) {
            $NewObj.ecs = $(if ($GeoLocation -eq 'Enabled') { $true } else { $false })
        }
        if ($SafeSearch) {
            $NewObj.safe_search = $(if ($SafeSearch -eq 'Enabled') { $true } else { $false })
        }
        if ($BlockDNSRebinding) {
            $NewObj.block_dns_rebind_attack = $(if ($BlockDNSRebinding -eq 'Enabled') { $true } else { $false })
        }
        if ($LocalOnPremResolution) {
            $NewObj.onprem_resolve = $(if ($LocalOnPremResolution -eq 'Enabled') { $true } else { $false })
        }
        if ($Tags) {
            $NewObj.tags = $Tags
        }
        if ($DoHPerPolicy) {
            $NewObj.doh_enabled = $(if ($DoHPerPolicy -eq 'Enabled') { $true } else { $false })
            if ($NewObj.doh_enabled) {
                if ($NewObj.doh_fqdn -eq '') {
                    $NewObj.doh_fqdn = (New-B1DoHFQDN).doh_fqdn
                }
            }
        }
        if ($DFPs) {
            $DFPs | ForEach-Object {
                $DFPService = Get-B1Service -Type dfp -Name $_ -Detailed -Strict
                if ($DFPService) {
                    $NewObj.dfp_services += $DFPService.id
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
                    $NewObj.network_lists += $ExternalNetwork.id
                } else {
                    Write-Error "Unable to find External Network: $($_)"
                    return $null
                }
            }
        }
        if ($IPAMNetworks) {
            $NewObj.net_address_dfps = @($IPAMNetworks)
        }
        if ($Rules) {
            $NewObj.rules = $Rules
        }

        $JSON = $NewObj | ConvertTo-Json -Depth 5 -Compress
        if($PSCmdlet.ShouldProcess("Update Security Policy:`n$(JSONPretty($JSON))","Update Security Policy: $($NewObj.name)",$MyInvocation.MyCommand)){
            $Result = Invoke-CSP -Method PUT -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/security_policies/$($Object.id)" -Data $JSON | Select-Object -ExpandProperty results -EA SilentlyContinue -WA SilentlyContinue
            if ($Result.id -eq $Object.id) {
                return $Result
            } else {
                Write-Host "Failed to update Security Policy: $Name." -ForegroundColor Red
                break
            }
        }
    }
}