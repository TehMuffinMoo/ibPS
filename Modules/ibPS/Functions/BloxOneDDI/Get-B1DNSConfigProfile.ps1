﻿function Get-B1DNSConfigProfile {
    <#
    .SYNOPSIS
        Retrieves a list of DNS Config Profiles from BloxOneDDI

    .DESCRIPTION
        This function is used to query a list of DNS Config Profiles from BloxOneDDI

    .PARAMETER Name
        The name of the DNS Config Profile

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .PARAMETER Limit
        Use this parameter to limit the quantity of results. The default number of results is 1000.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .PARAMETER tfilter
        Use this parameter to filter the results returned by tag.

    .PARAMETER Fields
        Specify a list of fields to return. The default is to return all fields.
        
    .PARAMETER id
        Return results based on DNS Config Profile id

    .EXAMPLE
        Get-B1DNSConfigProfile -Name "Data Centre" -Strict
    
    .FUNCTIONALITY
        BloxOneDDI
    #>
    param(
        [String]$Name,
        [Switch]$Strict,
        [Int]$Limit = 1000,
        [Int]$Offset = 0,
        [String]$tfilter,
        [String[]]$Fields,
        [String]$id
    )
    $MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    [System.Collections.ArrayList]$QueryFilters = @()
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($id) {
        $Filters.Add("id==`"$id`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
        $QueryFilters.Add("_filter=$Filter") | Out-Null
    }
    $QueryFilters.Add("_limit=$Limit") | Out-Null
    $QueryFilters.Add("_offset=$Offset") | Out-Null
    if ($tfilter) {
        $QueryFilters.Add("_tfilter=$tfilter") | Out-Null
    }
    if ($Fields) {
        $Fields += "id"
        $QueryFilters.Add("_fields=$($Fields -join ",")") | Out-Null
    }
    if ($QueryFilters) {
        $QueryString = ConvertTo-QueryString $QueryFilters
    }

    if ($QueryString) {
        Query-CSP -Method GET -Uri "dns/server$QueryString" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }else {
        Query-CSP -Method GET -Uri "dns/server" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
}