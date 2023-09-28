function Get-B1DNSHost {
    <#
    .SYNOPSIS
        Retrieves a list of BloxOneDDI DNS Hosts

    .DESCRIPTION
        This function is used to query a list of BloxOneDDI DNS Hosts

    .PARAMETER Name
        The name of the DNS Host to filter by

    .PARAMETER IP
        The IP of the DNS Host to filter by

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .Example
        Get-B1DNSHost -Name "bloxoneddihost1.mydomain.corp" -IP "10.10.10.10"
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DNS
    #>
    param(
        [String]$Name,
        [String]$IP,
        [switch]$Strict
    )
    $MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($IP) {
        $Filters.Add("address$MatchType`"$IP`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
    }
    if ($Filter) {
        Query-CSP -Method GET -Uri "dns/host?_filter=$Filter" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Query-CSP -Method GET -Uri "dns/host" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    }
}