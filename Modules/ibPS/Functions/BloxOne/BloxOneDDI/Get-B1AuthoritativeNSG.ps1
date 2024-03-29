﻿function Get-B1AuthoritativeNSG {
    <#
    .SYNOPSIS
        Retrieves a list of Authoritative DNS Server Groups from BloxOneDDI

    .DESCRIPTION
        This function is used to query a list Authoritative DNS Server Groups from BloxOneDDI

    .PARAMETER Name
        The name of the Authoritative DNS Server Group

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .PARAMETER tfilter
        Use this parameter to filter the results returned by tag.

    .PARAMETER Fields
        Specify a list of fields to return. The default is to return all fields.

    .PARAMETER id
        Return results based on the authoritative NSG id

    .EXAMPLE
        PS> Get-B1AuthoritativeNSG -Name "Data Centre" -Strict
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DNS
    #>
    param(
        [String]$Name,
        [Switch]$Strict = $false,
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
        Query-CSP -Method GET -Uri "dns/auth_nsg$($QueryString)" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Query-CSP -Method GET -Uri "dns/auth_nsg" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
}