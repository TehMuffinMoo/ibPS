function Get-B1IPAMHost {
    <#
    .SYNOPSIS
        Retrieves a list of host objects from IPAM

    .DESCRIPTION
        This function is used to query a list of host objects from IPAM.

    .PARAMETER Name
        Filter results by the host object name

    .PARAMETER Description
        Filter results by the host object description

    .PARAMETER Limit
        Limits the number of results returned, the default is 100

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .PARAMETER Fields
        Specify a list of fields to return. The default is to return all fields.

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .PARAMETER OrderBy
        Optionally return the list ordered by a particular value. If sorting is allowed on non-flat hierarchical resources, the service should implement a qualified naming scheme such as dot-qualification to reference data down the hierarchy. Using 'asc' or 'desc' as a suffix will change the ordering, with ascending as default.

    .PARAMETER OrderByTag
        Optionally return the list ordered by a particular tag value. Using 'asc' or 'desc' as a suffix will change the ordering, with ascending as default.

    .PARAMETER tfilter
        Use this parameter to filter the results returned by tag.

    .PARAMETER CaseSensitive
        Use Case Sensitive matching. By default, case-insensitive matching both for -Strict matching and regex matching.

    .PARAMETER id
        Use this parameter to query a particular host object by id

    .EXAMPLE
        PS> Get-B1Host -Name "my-host" -Strict

    .EXAMPLE
        PS> Get-B1Host -Limit 50 -Offset 100

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        DHCP
    #>
    [CmdletBinding()]
    param (
        [String]$Name,
        [String]$Description,
        [Int]$Limit = 100,
        [Int]$Offset = 0,
        [Switch]$Strict = $false,
        [String[]]$Fields,
        [String]$OrderBy,
        [String]$OrderByTag,
        [String]$tfilter,
        [Switch]$CaseSensitive,
        [String]$id
    )

    process {
        $MatchType = Match-Type $Strict $CaseSensitive

        [System.Collections.ArrayList]$Filters = @()
        [System.Collections.ArrayList]$QueryFilters = @()
        if ($Name) {
            $Filters.Add("name$($MatchType)`"$($Name)`"") | Out-Null
        }
        if ($Description) {
            $Filters.Add("comment$($MatchType)`"$($Description)`"") | Out-Null
        }
        if ($id) {
            $Filters.Add("id==`"$id`"") | Out-Null
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
            Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/ddi/v1/ipam/host$QueryString" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
        } else {
            Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/ddi/v1/ipam/host" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
        }
    }
}