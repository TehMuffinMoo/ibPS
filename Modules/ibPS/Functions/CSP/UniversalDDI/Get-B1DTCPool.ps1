function Get-B1DTCPool {
    <#
    .SYNOPSIS
        Retrieves a list of Universal DDI DTC Pools

    .DESCRIPTION
        This function is used to query a list of Universal DDI DTC Pools

    .PARAMETER Name
        The name of the DTC Pool to filter by

    .PARAMETER Description
        The description of the DTC Pool to filter by

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
        Return results based on Pool id

    .EXAMPLE
        PS> Get-B1DTCPool -Name 'DTC-Exchange'

        id                          : dtc/pool/656yhrft-gdf5-4gfs-tfg5-gg5ghbtg44d9
        name                        : DTC-Exchange
        comment                     :
        tags                        :
        disabled                    : False
        method                      : ratio
        servers                     : {@{server_id=dtc/server/vdr5g5t-fgfg-gds4-svsv-f44gdbdbfbvbxv; name=EXCHANGE-MAIL01; weight=2}, @{server_id=dtc/server/348t54gg8-r3f4-g455-g4vr-sdvre545g3; name=EXCHANGE-MAIL02; weight=1}}
        ttl                         : 0
        inheritance_sources         :
        pool_availability           : any
        pool_servers_quorum         : 0
        server_availability         : all
        server_health_checks_quorum : 0
        health_checks               : {@{health_check_id=dtc/health_check_icmp/ac9fcsvf1-ggjh-fdbg-adfd-h56hnbtjyngv; name=ICMP health check}, @{health_check_id=dtc/health_check_http/dgferhg5-ge5e-g455-gb45-muymkfdsdfcf; name=Exchange - HTTPS}}
        metadata                    :

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        DNS
    #>
    [CmdletBinding()]
    param(
        [String]$Name,
        [String]$Description,
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
    if ($tfilter) {
        $QueryFilters.Add("_tfilter=$tfilter") | Out-Null
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
        Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/ddi/v1/dtc/pool$QueryString" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/ddi/v1/dns/dtc/pool" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
}