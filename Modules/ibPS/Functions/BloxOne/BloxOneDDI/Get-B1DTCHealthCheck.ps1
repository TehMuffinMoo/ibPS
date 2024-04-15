function Get-B1DTCHealthCheck {
    <#
    .SYNOPSIS
        Retrieves a list BloxOne DTC Health Checks

    .DESCRIPTION
        This function is used to query a list BloxOne Health Checks

    .PARAMETER Name
        The name of the DTC Health Check to filter by

    .PARAMETER Description
        The description of the DTC Health Check to filter by

    .PARAMETER Type
        Filter by the DTC Health Check Type

    .PARAMETER Status
        Filter by the Health Check status (Enabled/Disabled)

    .PARAMETER Port
        Filter by the DTC Health Check Port

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

    .PARAMETER id
        Return results based on Server id

    .EXAMPLE
        PS> Get-B1DTCHealthCheck -Type HTTP | ft -AutoSize

        name                    comment                   type disabled interval timeout retry_up retry_down tags port http request                                                             codes id
        ----                    -------                   ---- -------- -------- ------- -------- ---------- ---- ---- ---- -------                                                             ----- --
        HTTP health check       Default HTTP health check http    False       15      10        1          1        80      GET / HTTP/1.1…                                                     200   dtc/health_check_http/ac9htthh-h754-t4hg-45gu-fdsgf98wwd4v
        Exchange - HTTPS                                  http    False       10      10        3          3       443      GET /owa/auth/logon.aspx HTTP/1.1                                         dtc/health_check_http/dgferhg5-ge5e-g455-gb45-muymkfdsdfcf

    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DNS
    #>
    param(
        [String]$Name,
        [String]$Description,
        [ValidateSet("ICMP", "TCP", "HTTP")]
        [String]$Type,
        [ValidateSet("Enabled", "Disabled")]
        [String]$Status,
        [Int]$Port,
        [Switch]$Strict,
        [Int]$Limit = 1000,
        [Int]$Offset = 0,
        [String]$tfilter,
        [String[]]$Fields,
        [String]$OrderBy,
        [String]$OrderByTag,
        [String]$id
    )
    $MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    [System.Collections.ArrayList]$QueryFilters = @()
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($Description) {
        $Filters.Add("comment$MatchType`"$Description`"") | Out-Null
    }
    if ($Type) {
        $Filters.Add("type==`"$Type`"") | Out-Null
    }
    if ($Port) {
        $Filters.Add("port==$Port") | Out-Null
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
        Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/ddi/v1/dtc/health_check_all$QueryString" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/ddi/v1/dns/dtc/health_check_all" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
}