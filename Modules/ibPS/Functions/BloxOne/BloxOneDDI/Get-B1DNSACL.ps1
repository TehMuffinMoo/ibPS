function Get-B1DNSACL {
    <#
    .SYNOPSIS
        Retrieves a list of BloxOneDDI DNS Access Control Lists

    .DESCRIPTION
        This function is used to query a list of BloxOneDDI DNS Access Control Lists

    .PARAMETER Name
        The name of the DNS Access Control List to filter by

    .PARAMETER Limit
        Use this parameter to limit the quantity of results. The default number of results is 100.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .PARAMETER tfilter
        Use this parameter to filter the results returned by tag.

    .PARAMETER Fields
        Specify a list of fields to return. The default is to return all fields.

    .PARAMETER OrderBy
        Optionally return the list ordered by a particular value. If sorting is allowed on non-flat hierarchical resources, the service should implement a qualified naming scheme such as dot-qualification to reference data down the hierarchy. Using 'asc' or 'desc' as a suffix will change the ordering, with ascending as default.

    .PARAMETER OrderByTag
        Optionally return the list ordered by a particular tag value. Using 'asc' or 'desc' as a suffix will change the ordering, with ascending as default.

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .PARAMETER CustomFilters
        Accepts either an Object, ArrayList or String containing one or more custom filters.
        See here for usage: https://ibps.readthedocs.io/en/latest/#-customfilters

    .PARAMETER id
        Return results based on DNS Access Control List id
        
    .EXAMPLE
        PS> Get-B1DNSACL -Name "Servers_ACL"
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DNS
    #>
    param(
        [String]$Name,
        [Int]$Limit = 100,
        [Int]$Offset = 0,
        [String[]]$Fields,
        [String]$tfilter,
        [String]$OrderBy,
        [String]$OrderByTag,
        [switch]$Strict,
        $CustomFilters,
        [String]$id
    )

	$MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    [System.Collections.ArrayList]$QueryFilters = @()
    if ($CustomFilters) {
        $Filters.Add($CustomFilters) | Out-Null
    }
    if ($id) {
        $Filters.Add("id==`"$id`"") | Out-Null
    }
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($Source) {
        $Filters.Add("source$MatchType`"$Source`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
        $QueryFilters.Add("_filter=$Filter") | Out-Null
    }
    if ($Limit) {
        $QueryFilters.Add("_limit=$Limit") | Out-Null
    }
    if ($Offset) {
        $QueryFilters.Add("_offset=$Offset") | Out-Null
    }
    if ($Fields) {
        $Fields += "id"
        $QueryFilters.Add("_fields=$($Fields -join ",")") | Out-Null
    }
    if ($tfilter) {
        $QueryFilters.Add("_tfilter=$tfilter") | Out-Null
    }
    if ($OrderBy) {
        $QueryFilters.Add("_order_by=$OrderBy") | Out-Null
    }
    if ($OrderByTag) {
        $QueryFilters.Add("_torder_by=$OrderByTag") | Out-Null
    }
    if ($QueryFilters) {
        $QueryString = ConvertTo-QueryString $QueryFilters
    }
    Write-DebugMsg -Filters $QueryFilters
    if ($QueryString) {
        $Results = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/ddi/v1/dns/acl$($QueryString)" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        $Results = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/ddi/v1/dns/acl" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
    if ($Results) {
        #return [DNSACLArray]::New($Results) | Select-Object -ExpandProperty DNSACLs
        return $Results
    }
}