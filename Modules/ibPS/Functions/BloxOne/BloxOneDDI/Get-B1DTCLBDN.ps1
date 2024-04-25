function Get-B1DTCLBDN {
    <#
    .SYNOPSIS
        Retrieves a list BloxOne DTC LBDNs

    .DESCRIPTION
        This function is used to query a list BloxOne DTC LBDNs

    .PARAMETER Name
        The name of the DTC LBDN to filter by

    .PARAMETER Description
        The description of the DTC LBDN to filter by

    .PARAMETER View
        Filter by the name of the DNS View the DTC LBDN is located in

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .PARAMETER Status
        Filter by the LBDN status (Enabled/Disabled)
        
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
        Return results based on LBDN id

    .EXAMPLE
        PS> Get-B1DTCLBDN

        id                  : dtc/lbdn/13fdfsfs-sdff-f8vk-vn09-cfvdij9gfr4
        name                : email.domain.corp.
        view                : dns/view/0f9fdgr4-97d7-sz9c-cv94-sgfdsg94r76
        dtc_policy          : @{policy_id=dtc/policy/ffdsfsf-f4tg-g54y-gg5h-fge765gg6; name=Exchange}
        precedence          : 50
        comment             : 
        disabled            : False
        ttl                 : 0
        tags                : 
        inheritance_sources :
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DNS
    #>
    param(
        [String]$Name,
        [String]$Description,
        [String]$View,
        [ValidateSet("Enabled", "Disabled")]
        [String]$Status,
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
    if ($View) {
        $ViewID = (Get-B1DNSView -Name $View -Strict).id
        if ($ViewID) {
            $Filters.Add("view==`"$ViewID`"") | Out-Null
        } else {
            Write-Error "Unable to find DNS View: $($View)"
            return $null
        }
    }
    if ($Status) {
        if ($Status -eq 'Enabled') {
            $StatusVal = $False
        } else {
            $StatusVal = $True
        }
        $Filters.Add("disabled==$StatusVal") | Out-Null
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
        Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/ddi/v1/dtc/lbdn$QueryString" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/ddi/v1/dns/dtc/lbdn" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
}