﻿function Get-B1ForwardZone {
    <#
    .SYNOPSIS
        Retrieves a list of forward zones from BloxOneDDI

    .DESCRIPTION
        This function is used to query a list forward zones from BloxOneDDI

    .PARAMETER FQDN
        The fqdn of the forward zone to filter by

    .PARAMETER Disabled
        Filter results based on if the forward zone is disabled or not

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .PARAMETER View
        The DNS View where the forward zone(s) are located

    .PARAMETER Limit
        Use this parameter to limit the quantity of results. The default number of results is 1000.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .PARAMETER tfilter
        Use this parameter to filter the results returned by tag.

    .PARAMETER id
        Filter the results by forward zone id

    .EXAMPLE
        Get-B1ForwardZone -FQDN "prod.mydomain.corp"
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DNS
    #>
    param(
      [String]$FQDN,
      [bool]$Disabled,
      [switch]$Strict = $false,
      [String]$View,
      [Int]$Limit = 1000,
      [Int]$Offset = 0,
      [String]$tfilter,
      [String]$id
    )
    if ($View) {$ViewUUID = (Get-B1DNSView -Name $View -Strict).id}
	$MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    [System.Collections.ArrayList]$QueryFilters = @()
    if ($FQDN) {
        $Filters.Add("fqdn$MatchType`"$FQDN`"") | Out-Null
    }
    if ($Disabled) {
        $Filters.Add("disabled==`"$Disabled`"") | Out-Null
    }
    if ($ViewUUID) {
        $Filters.Add("view==`"$ViewUUID`"") | Out-Null
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
    if ($QueryFilters) {
        $QueryString = ConvertTo-QueryString $QueryFilters
    }
    if ($QueryString) {
        Query-CSP -Method GET -Uri "dns/forward_zone$($QueryString)" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Query-CSP -Method GET -Uri "dns/forward_zone?_limit=$Limit&_offset=$Offset" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
}