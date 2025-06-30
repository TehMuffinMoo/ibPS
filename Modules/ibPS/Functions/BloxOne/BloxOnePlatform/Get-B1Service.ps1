function Get-B1Service {
    <#
    .SYNOPSIS
        Retrieves a list of Infoblox Portal Services

    .DESCRIPTION
        This function is used to query a list of deployed Infoblox Portal Services/Containers

    .PARAMETER Name
        Filters the results by the name of the container

    .PARAMETER Type
        Filters based on the type of service

    .PARAMETER Detailed
        Additionally returns related host information

    .PARAMETER Limit
        Use this parameter to limit the quantity of results. The default number of results is 10001.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

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

    .PARAMETER id
        Use the id parameter to filter the results by ID

    .EXAMPLE
        PS> Get-B1Service -Name "dns_ddihost1.mydomain.corp" -Detailed -Strict

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        Service
    #>
    [CmdletBinding()]
    param(
        [Parameter(ParameterSetName="Default",Mandatory=$false)]
        [String]$Name,
        [String]$Type,
        [Switch]$Detailed,
        [Int]$Limit = "10001",
        [Int]$Offset = 0,
        [Switch]$Strict,
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
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($id) {
        $Filters.Add("id==`"$id`"") | Out-Null
    }
    if ($Type) {
        $Filters.Add("service_type==`"$Type`"") | Out-Null
    }
    if ($Detailed) {
      $ServicesUri = "detail_services"
    } else {
      $ServicesUri = "services"
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters -CaseSensitive:$CaseSensitive
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
        $Results = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/infra/v1/$($ServicesUri)$($QueryString)" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        $Results = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/infra/v1/$($ServicesUri)" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }

    if ($Results) {
        return $Results
    }
}