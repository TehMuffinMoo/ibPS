function Get-B1DNSConfigProfile {
    <#
    .SYNOPSIS
        Retrieves a list of DNS Config Profiles from BloxOneDDI

    .DESCRIPTION
        This function is used to query a list of DNS Config Profiles from BloxOneDDI

    .PARAMETER Name
        The name of the DNS Config Profile

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .Example
        Get-B1DNSConfigProfile -Name "Data Centre" -Strict
    
    .FUNCTIONALITY
        BloxOneDDI
    #>
    param(
        [String]$Name,
        [Switch]$Strict,
        [string]$id
    )
    $MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($id) {
        $Filters.Add("id==`"$id`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
    }

    if ($Filter) {
        Query-CSP -Method GET -Uri "dns/server?_filter=$Filter" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }else {
        Query-CSP -Method GET -Uri "dns/server" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
}