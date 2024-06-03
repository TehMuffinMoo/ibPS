function Set-B1SecurityPolicy {
    <#
    .SYNOPSIS
        Updates an existing Security Policy in BloxOne Threat Defense

    .DESCRIPTION
        This function is used to update an existing Security Policy in BloxOne Threat Defense.

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

    .EXAMPLE
        

    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Threat Defense
    #>
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
      [System.Object]$Object
    )

    process {
        if ('onprem_resolve' -notin $Object.PSObject.Properties.Name) {
            Write-Error "Unsupported pipeline object. This function only supports Security Policy objects as input. (Get-B1SecurityPolicy)"
            return $null
        }

        $NewObj = $Object | Select-Object * -ExcludeProperty id,created_time,updated_time

        if ($DoHPerPolicy) {
            $NewObj.doh_enabled = $(if ($DoHPerPolicy -eq 'Enabled') { $true } else { $false })
            if ($NewObj.doh_enabled) {
                if ($NewObj.doh_fqdn -eq '') {
                    $NewObj.doh_fqdn = (New-B1DoHFQDN).doh_fqdn
                }
            }
        }

        if ($DFPs) {
            $DFPs | %{
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
            $ExternalNetworks | %{
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

        $JSON = $NewObj | ConvertTo-Json -Depth 5

        $Result = Invoke-CSP -Method PUT -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/security_policies/$($Object.id)" -Data $JSON | Select-Object -ExpandProperty results -EA SilentlyContinue -WA SilentlyContinue
        if ($Result.id -eq $Object.id) {
            return $Result
        } else {
            Write-Host "Failed to update Security Policy: $Name." -ForegroundColor Red
            break
        }

    }
}