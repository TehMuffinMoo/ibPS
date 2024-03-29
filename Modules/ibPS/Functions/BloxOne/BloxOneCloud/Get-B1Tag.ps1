﻿function Get-B1Tag {
    <#
    .SYNOPSIS
        Retrieves a list of BloxOneDDI Tags

    .DESCRIPTION
        This function is used to query a list of BloxOneDDI Tags

    .PARAMETER Name
        The name of the tag to filter by

    .PARAMETER Status
        The status of the tag to filter by

    .PARAMETER Fields
        Specify a list of fields to return. The default is to return all fields.
        
    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .EXAMPLE
        PS> Get-B1Tag -Name "siteCode"
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Tags
    #>
    param(
        [String]$Name,
        [ValidateSet("active","revoked")]
        [String]$Status,
        [switch]$Strict,
        [String[]]$Fields
    )
	$MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    [System.Collections.ArrayList]$QueryFilters = @()
    if ($Name) {
        $Filters.Add("key$MatchType`"$Name`"") | Out-Null
    }
    if ($Status) {
        $Filters.Add("status$MatchType`"$Status`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
        $QueryFilters.Add("_filter=$Filter") | Out-Null
    }
    if ($Fields) {
        $Fields += "id"
        $QueryFilters.Add("_fields=$($Fields -join ",")") | Out-Null
    }

    if ($QueryFilters) {
        $QueryString = ConvertTo-QueryString $QueryFilters
    }
    if ($QueryString) {
        Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/atlas-tagging/v2/tags$($QueryString)" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/atlas-tagging/v2/tags" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
}