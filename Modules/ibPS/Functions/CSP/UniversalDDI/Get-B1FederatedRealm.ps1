function Get-B1FederatedRealm {
    <#
    .SYNOPSIS
        Queries a list of Federated Realms from the Universal DDI IPAM

    .DESCRIPTION
        This function is used to query a list of Federated Realms from the Universal DDI IPAM

    .PARAMETER Name
        Use this parameter to filter the list of Federated Realms by name

    .PARAMETER Description
        Use this parameter to filter the list of Federated Realms by description

    # .PARAMETER UtilizationLow
    #     Use this parameter to filter the list of Federated Realms with a utilization above the low utilization threshold

    # .PARAMETER UtilizationHigh
    #     Use this parameter to filter the list of Federated Realms with a utilization below the high utilization threshold

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

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
        Use this parameter to query a particular federated realm id

    .EXAMPLE
        PS> Get-B1FederatedRealm -Name "Corporate" -Strict

        allocation_v4  : @{allocated=32; delegated=12; forward_looking_delegation=3; overlapping=1; reserved=7}
        comment        : Corporate Federated Realm
        created_at     : 04/03/2026 13:40:50
        id             : federation/federated_realm/2bff55cf-9bb9-441f-bf06-df53e9358aa3
        metadata       :
        name           : Corporate
        provider       : NIOS_X
        region         :
        tags           :
        updated_at     : 26/06/2026 12:10:05
        utilization    : 0
        utilization_v6 :

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        IPAM
    #>
    [CmdletBinding()]
    param(
      [String]$Name,
      [String]$Description,
    #   [ValidateRange(0,100)] - Currently broken on backend API
    #   [Int]$UtilizationLow = 0,
    #   [ValidateRange(0,100)]
    #   [Int]$UtilizationHigh = 100,
      [Switch]$Strict,
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
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($Description) {
        $Filters.Add("comment$MatchType`"$Description`"") | Out-Null
    }
    # Currently broken on backend API. Works via htree which is used in the UI, but official APIs should be used where possible
    # if ($UtilizationLow -or $UtilizationHigh) {
    #     $Filters.Add("utilization>=$UtilizationLow and utilization<=$UtilizationHigh") | Out-Null
    # }
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
    if ($QueryFilters) {
        $QueryString = ConvertTo-QueryString $QueryFilters
    }
    Write-DebugMsg -Filters $QueryFilters
    if ($QueryString) {
        Invoke-CSP -Uri "$(Get-B1CSPUrl)/api/ddi/v1/federation/federated_realm$($QueryString)" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Invoke-CSP -Uri "$(Get-B1CSPUrl)/api/ddi/v1/federation/federated_realm?_limit=$Limit&_offset=$Offset" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
}