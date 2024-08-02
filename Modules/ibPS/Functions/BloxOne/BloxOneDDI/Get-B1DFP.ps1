function Get-B1DFP {
    <#
    .SYNOPSIS
        Queries a list of BloxOneDDI DFPs (DNS Forwarding Proxies)

    .DESCRIPTION
        Use this method query a list of BloxOneDDI DFPs (DNS Forwarding Proxies)

    .PARAMETER Name
        Filter the results by name

    .PARAMETER SiteID
        Filter the results by site_id

    .PARAMETER OPHID
        Filter the results by ophid

    .PARAMETER PolicyID
        Filter the results by policy_id

    .PARAMETER DefaultSecurityPolicy
        Switch value to filter by default security policy

    .PARAMETER id
        Filter the results by id

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

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

    .PARAMETER CustomFilters
        Accepts either an Object, ArrayList or String containing one or more custom filters.
        See here for usage: https://ibps.readthedocs.io/en/latest/#-customfilters

    .PARAMETER CaseSensitive
        Use Case Sensitive matching. By default, case-insensitive matching both for -Strict matching and regex matching.

    .EXAMPLE
        PS> Get-B1DFP -Name "My DFP" -Strict

    .EXAMPLE
        PS> Get-B1DFP -DefaultSecurityPolicy

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        BloxOne Threat Defense
    #>
    [CmdletBinding()]
    param(
        [String[]]$Name,
        [String]$SiteID,
        [String]$OPHID,
        [Int]$PolicyID,
        [Switch]$DefaultSecurityPolicy,
        [Switch]$Strict,
        [Int]$Limit = 100,
        [Int]$Offset = 0,
        [String]$tfilter,
        [String[]]$Fields,
        [String]$OrderBy,
        [String]$OrderByTag,
        $CustomFilters,
        [Switch]$CaseSensitive,
        [String]$id
    )
    $MatchType = Match-Type $Strict $CaseSensitive

    [System.Collections.ArrayList]$Filters = @()
    [System.Collections.ArrayList]$QueryFilters = @()
    if ($CustomFilters) {
        $Filters.Add($CustomFilters) | Out-Null
    }
    if ($Name) {
      $Filters.Add("name$($MatchType)`"$Name`"") | Out-Null
    }
    if ($SiteID) {
      $Filters.Add("site_id$($MatchType)`"$SiteID`"") | Out-Null
    }
    if ($OPHID) {
      $Filters.Add("ophid$($MatchType)`"$OPHID`"") | Out-Null
    }
    if ($PolicyID) {
      $Filters.Add("policy_id==$PolicyID") | Out-Null
    }
    if ($id) {
      $Filters.Add("id==$id") | Out-Null
    }
    if ($DefaultSecurityPolicy) {
      $Filters.Add("default_security_policy==$DefaultSecurityPolicy") | Out-Null
    }
    if ($Filters) {
        $Filter = (Combine-Filters $Filters -CaseSensitive:$CaseSensitive)
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
        $QueryFilters.Add("_order_by=$($OrderBy)") | Out-Null
    }
    if ($OrderByTag) {
        $QueryFilters.Add("_torder_by=$OrderByTag") | Out-Null
    }
    if ($QueryFilters) {
      $QueryString = ConvertTo-QueryString $QueryFilters
    }
    Write-DebugMsg -Filters $QueryFilters
    if ($id) {
      $Results = Invoke-CSP -Uri "$(Get-B1CspUrl)/api/atcdfp/v1/dfps/$id$QueryString" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } elseif ($QueryString) {
      $Results = Invoke-CSP -Uri "$(Get-B1CspUrl)/api/atcdfp/v1/dfps$QueryString" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
      $Results = Invoke-CSP -Uri "$(Get-B1CspUrl)/api/atcdfp/v1/dfps" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }

    if ($Results) {
      return $Results
    }
}