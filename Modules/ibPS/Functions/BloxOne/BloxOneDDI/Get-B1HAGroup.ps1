function Get-B1HAGroup {
    <#
    .SYNOPSIS
        Queries a list of HA Groups from BloxOneDDI

    .DESCRIPTION
        This function is used to query a list of HA Group(s) from BloxOneDDI

    .PARAMETER Name
        The name of the HA Group to filter by

    .PARAMETER CollectStats
        Use the -CollectStats parameter to collect additional information about the selected HA Group(s). This includes HA Group Status and member metrics (heartbeats is added under hosts).

    .PARAMETER Mode
        The mode of the HA Group to filter by

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

    .PARAMETER CustomFilters
        Accepts either an Object, ArrayList or String containing one or more custom filters.
        See here for usage: https://ibps.readthedocs.io/en/latest/#-customfilters

    .PARAMETER id
        The id of the HA Group to filter by

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Low.
        
    .EXAMPLE
        PS> Get-B1HAGroup -Name "MyHAGroup" -Strict

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        IPAM

    .FUNCTIONALITY
        DHCP
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Low'
    )]
    param(
      [String]$Name,
      [Switch]$CollectStats,
      [String]$Mode,
      [Switch]$Strict = $false,
      [Int]$Limit = 1000,
      [Int]$Offset = 0,
      [String]$tfilter,
      [String[]]$Fields,
      [String]$OrderBy,
      [String]$OrderByTag,
      $CustomFilters,
      [String]$id
    )

	$MatchType = Match-Type $Strict

    [System.Collections.ArrayList]$Filters = @()
    [System.Collections.ArrayList]$QueryFilters = @()
    if ($CustomFilters) {
        $Filters.Add($CustomFilters) | Out-Null
    }
    if ($Name) {
        $Filters.Add("name$MatchType`"$name`"") | Out-Null
    }
    if ($Mode) {
        if ($Mode -eq "active-active" -or $Mode -eq "active-passive") {
            $Filters.Add("mode==`"$Mode`"") | Out-Null
        } else {
            Write-Host "Error: -Mode must be `"active-active`" or `"active-passive`"" -ForegroundColor Red
            break
        }
    }
    if ($id) {
        $Filters.Add("id==`"$id`"") | Out-Null
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
    if ($CollectStats) {
        $QueryFilters.Add("collect_stats=true") | Out-Null
    }
    if ($QueryFilters) {
        $QueryString = ConvertTo-QueryString $QueryFilters
    }
    Write-DebugMsg -Filters $QueryFilters
    if ($QueryString) {
        $Results = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/ddi/v1/dhcp/ha_group$($QueryString)" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        $Results = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/ddi/v1/dhcp/ha_group" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }

    if ($Results) {
        return $Results
    } else {
        Write-Verbose "No DHCP HA Groups found."
    }
}