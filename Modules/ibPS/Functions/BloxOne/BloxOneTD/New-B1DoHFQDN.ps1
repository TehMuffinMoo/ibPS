function New-B1DoHFQDN {
    <#
    .SYNOPSIS
        Generates a new DoH FQDN

    .DESCRIPTION
        This function is used to generate a new DNS over HTTPS FQDN for use in BloxOne Threat Defense security policies

    .EXAMPLE
        PS> New-B1DoHFQDN                                                                                                                        
                                                                                                                                
        policy_id doh_fqdn
        --------- --------
                0 dfsdgghhdh-btrb-4bbb-bffb-cmjumbfgfnhm9.doh.threatdefense.infoblox.com

    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Threat Defense
    #>
    param(
    )

    $Result = Invoke-CSP -Method POST -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/doh_fqdns" | Select-Object -ExpandProperty results -EA SilentlyContinue -WA SilentlyContinue
    if ($Result) {
        return $Result
    } else {
        Write-Error "Failed to generate a new DNS over HTTPS FQDN."
    }

}