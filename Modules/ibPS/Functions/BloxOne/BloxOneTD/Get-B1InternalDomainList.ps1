function Get-B1InternalDomainList {
    <#
    .SYNOPSIS
        Retrieves information on Internal Domain objects for this account

    .DESCRIPTION
        This function is used to retrieve information on Internal Domain objects for this account

    .PARAMETER Name
        Filter results by Name

    .PARAMETER Description
        Filter results by Description

    .PARAMETER IsDefault
        Filter results by the default domain list

    .PARAMETER Limit
        Use this parameter to limit the quantity of results. The default number of results is 1000.

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
        Filter the results by id

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .EXAMPLE
        PS> Get-B1InternalDomainList -IsDefault

        created_time     : 4/22/2020 9:21:30PM
        description      : Auto-generated
        id               : 123456
        internal_domains : {example, example.com, example.net, example.org…}
        is_default       : True
        name             : Default Bypass Domains/CIDRs
        tags             :
        updated_time     : 1/20/2023 1:43:23PM

    .EXAMPLE
        PS> Get-B1InternalDomainList -Name 'Default'

        created_time     : 4/22/2020 9:21:30PM
        description      : Auto-generated
        id               : 123456
        internal_domains : {example, example.com, example.net, example.org…}
        is_default       : True
        name             : Default Bypass Domains/CIDRs
        tags             :
        updated_time     : 1/20/2023 1:43:23PM

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Threat Defense
    #>
    [CmdletBinding(DefaultParameterSetName="Default")]
    param(
        [Parameter(ParameterSetName="Default")]
        [String]$Name,
        [Parameter(ParameterSetName="Default")]
        [String]$Description,
        [Parameter(ParameterSetName="Default")]
        [Switch]$IsDefault,
        [Parameter(ParameterSetName="Default")]
        [Switch]$Strict,
        [Parameter(ParameterSetName="Default")]
        [Int]$Limit,
        [Parameter(ParameterSetName="Default")]
        [Int]$Offset,
        [Parameter(ParameterSetName="Default")]
        [String]$tfilter,
        [Parameter(ParameterSetName="Default")]
        [String[]]$Fields,
        [Parameter(ParameterSetName="Default")]
        [String]$OrderBy,
        [Parameter(ParameterSetName="Default")]
        [String]$OrderByTag,
        [Parameter(ParameterSetName="Default")]
        $CustomFilters,
        [Parameter(ParameterSetName="With ID")]
        [String]$id
    )

    $MatchType = Match-Type $Strict

    [System.Collections.ArrayList]$Filters = @()
    [System.Collections.ArrayList]$QueryFilters = @()
    if ($CustomFilters) {
        $Filters.Add($CustomFilters) | Out-Null
    }
    if ($Name) {
        $Filters.Add("name$($MatchType)`"$Name`"") | Out-Null
    }
    if ($Description) {
        $Filters.Add("description$($MatchType)`"$Description`"") | Out-Null
    }
    if ($IsDefault) {
        $Filters.Add("is_default==`"true`"") | Out-Null
    }
    if ($id) {
        $Filters.Add("id==$id") | Out-Null
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
    if ($OrderBy) {
        $QueryFilters.Add("_order_by=$OrderBy") | Out-Null
    }
    if ($OrderByTag) {
        $QueryFilters.Add("_torder_by=$OrderByTag") | Out-Null
    }
    if ($tfilter) {
        $QueryFilters.Add("_tfilter=$tfilter") | Out-Null
    }
    if ($QueryFilters) {
        $QueryString = ConvertTo-QueryString $QueryFilters
    }
    Write-DebugMsg -Filters $QueryFilters
    if ($QueryString) {
        $Results = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/internal_domain_lists$QueryString" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        $Results = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/internal_domain_lists" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }

    if ($Results) {
        return $Results
    }
}