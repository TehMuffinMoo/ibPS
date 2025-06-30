function Get-B1Tag {
    <#
    .SYNOPSIS
        Retrieves a list of Universal DDI Tags

    .DESCRIPTION
        This function is used to query a list of Universal DDI Tags

    .PARAMETER Name
        The name of the tag to filter by

    .PARAMETER Status
        The status of the tag to filter by

    .PARAMETER Fields
        Specify a list of fields to return. The default is to return all fields.

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .PARAMETER Limit
        Use this parameter to limit the quantity of results. The default number of results is 100.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .PARAMETER CustomFilters
        Accepts either an Object, ArrayList or String containing one or more custom filters.
        See here for usage: https://ibps.readthedocs.io/en/latest/#-customfilters

    .EXAMPLE
        PS> Get-B1Tag -Name "siteCode"

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        Tags
    #>
    [CmdletBinding()]
    param(
        [String]$Name,
        [ValidateSet("active","revoked")]
        [String]$Status,
        [switch]$Strict,
        [String[]]$Fields,
        [Int]$Limit = 100,
        [Int]$Offset,
        $CustomFilters
    )

    $MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    [System.Collections.ArrayList]$QueryFilters = @()
    if ($CustomFilters) {
        $Filters.Add($CustomFilters) | Out-Null
    }
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
    if ($Limit) {
        $QueryFilters.Add("_limit=$($Limit)") | Out-Null
    }
    if ($Offset) {
        $QueryFilters.Add("_offset=$($Offset)") | Out-Null
    }

    if ($QueryFilters) {
        $QueryString = ConvertTo-QueryString $QueryFilters
    }
    Write-DebugMsg -Filters $QueryFilters
    if ($QueryString) {
        Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/atlas-tagging/v2/tags$($QueryString)" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/atlas-tagging/v2/tags" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
}