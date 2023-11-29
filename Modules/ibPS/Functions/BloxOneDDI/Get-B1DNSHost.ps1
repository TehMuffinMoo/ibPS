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

    .PARAMETER Limit
        Use this parameter to limit the quantity of results. The default number of results is 1000.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .PARAMETER tfilter
        Use this parameter to filter the results returned by tag.

    .PARAMETER id
        Return results based on DNS Config Profile id

    .EXAMPLE
        Get-B1DNSHost -Name "bloxoneddihost1.mydomain.corp" -IP "10.10.10.10"
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DNS
    #>
    param(
        [String]$Name,
        [String]$IP,
        [switch]$Strict,
        [Int]$Limit = 1000,
        [Int]$Offset = 0,
        [String]$tfilter,
        [String]$id
    )
    $MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    [System.Collections.ArrayList]$Filters2 = @()
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($IP) {
        $Filters.Add("address$MatchType`"$IP`"") | Out-Null
    }
    if ($id) {
        $Filters.Add("id==`"$id`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
        $Filters2.Add("_filter=$Filter") | Out-Null
    }
    $Filters2.Add("_limit=$Limit") | Out-Null
    $Filters2.Add("_offset=$Offset") | Out-Null
    if ($tfilter) {
        $Filters2.Add("_tfilter=$tfilter") | Out-Null
    }
    if ($Filters2) {
        $Filter2 = Combine-Filters2 $Filters2
    }
    if ($Filter2) {
        Query-CSP -Method GET -Uri "dns/host$Filter2" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Query-CSP -Method GET -Uri "dns/host" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
}