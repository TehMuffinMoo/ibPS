function Get-B1DHCPHardwareFilter {
    <#
    .SYNOPSIS
        Retrieves a list of DHCP Hardware Filters from BloxOneDDI.

    .DESCRIPTION
        This function is used to query a list of DHCP Hardware Filters from BloxOneDDI.

    .PARAMETER Name
        The name of the DHCP Hardware Filter to search for

    .PARAMETER Role
        The role of the DHCP Hardware Filter to search by (selection/values)

    .PARAMETER Protocol
        The IP version protocol of the DHCP Hardware Filter to search by

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .PARAMETER Limit
        Use this parameter to limit the quantity of results. The default number of results is 1000.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .PARAMETER Fields
        Specify a list of fields to return. The default is to return all fields.

    .PARAMETER OrderBy
        Optionally return the list ordered by a particular value. If sorting is allowed on non-flat hierarchical resources, the service should implement a qualified naming scheme such as dot-qualification to reference data down the hierarchy. Using 'asc' or 'desc' as a suffix will change the ordering, with ascending as default.

    .PARAMETER OrderByTag
        Optionally return the list ordered by a particular tag value. Using 'asc' or 'desc' as a suffix will change the ordering, with ascending as default.

    .PARAMETER CustomFilters
        Accepts either an Object, ArrayList or String containing one or more custom filters.
        See here for usage: https://ibps.readthedocs.io/en/latest/#-customfilters

    .EXAMPLE
        PS> Get-B1DHCPHardwareFilter

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        DHCP
    #>
    [CmdletBinding()]
    param(
        [String]$Name,
        [ValidateSet("values","selection")]
        [String]$Role,
        [ValidateSet("ip4","ip6")]
        [String]$Protocol,
        [String[]]$Fields,
        [Int]$Limit,
        [Int]$Offset,
        [String]$OrderBy,
        [String]$OrderByTag,
        [Switch]$Strict = $false,
        $CustomFilters
    )
	$MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    [System.Collections.ArrayList]$QueryFilters = @()
    if ($CustomFilters) {
        $Filters.Add($CustomFilters) | Out-Null
    }
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($Role) {
        $Filters.Add("role==`"$Protocol`"") | Out-Null
    }
    if ($Protocol) {
        $Filters.Add("protocol==`"$Protocol`"") | Out-Null
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
    if ($QueryFilters) {
        $QueryString = ConvertTo-QueryString $QueryFilters
    }
    Write-DebugMsg -Filters $QueryFilters
    if ($QueryString) {
        Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/ddi/v1/dhcp/hardware_filter$($QueryString)" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/ddi/v1/dhcp/hardware_filter" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
}