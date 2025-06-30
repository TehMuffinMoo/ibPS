function Get-B1DHCPHost {
    <#
    .SYNOPSIS
        Retrieves a list of BloxOneDDI DHCP Hosts

    .DESCRIPTION
        This function is used to query a list of BloxOneDDI DHCP Hosts

    .PARAMETER Name
        The name of the DHCP Host to filter by

    .PARAMETER IP
        The IP of the DHCP Host to filter by

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

    .PARAMETER Associations
        Obtain a list of associated subnets/ranges with this host

    .PARAMETER CustomFilters
        Accepts either an Object, ArrayList or String containing one or more custom filters.
        See here for usage: See here for usage: https://ibps.readthedocs.io/en/latest/#-customfilters

    .PARAMETER CaseSensitive
        Use Case Sensitive matching. By default, case-insensitive matching both for -Strict matching and regex matching.

    .PARAMETER id
        Return results based on DHCP Host id

    .EXAMPLE
        PS> Get-B1DHCPHost -Name "bloxoneddihost1.mydomain.corp" -IP "10.10.10.10"

    .EXAMPLE
        PS> $AssociatedSubnets = (Get-B1DHCPHost -Name "bloxoneddihost1.mydomain.corp" -Associations).Subnets
        PS> $AssociatedSubnets | ft name,address,cidr,comment

        name      address   cidr  comment
        --------  -------   ----  -------
        My Subnet 10.0.1.0  24    My Subnet Description
        Other Sub 10.10.2.0 24    Other Subnet Description


    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        DHCP
    #>
    [CmdletBinding()]
    param(
        [String]$Name,
        [String]$IP,
        [switch]$Strict,
        [Int]$Limit = 1000,
        [Int]$Offset = 0,
        [String]$tfilter,
        [String[]]$Fields,
        [String]$OrderBy,
        [String]$OrderByTag,
        [Switch]$Associations,
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
    if ($IP) {
        $Filters.Add("address==`"$IP`"") | Out-Null
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
        $Results = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/ddi/v1/dhcp/host$QueryString" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        $Results = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/ddi/v1/dhcp/host" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
    if ($Results -and $Associations) {
        $AssociationResults = @()
        foreach ($DHCPHost in $Results) {
            $AssociationItem = Invoke-CSP -Method GET -Uri "$($DHCPHost.id)/associations"
            $AssociationResults += @{
                "Host" = $DHCPHost.name
                "HAGroups" = $AssociationItem.ha_groups
                "Subnets" = $AssociationItem.subnets
                "HostInfo" = $AssociationItem.host
            }
        }
    }
    if ($AssociationResults) {
        $AssociationResults | ConvertTo-Json -Depth 15 | ConvertFrom-Json -Depth 15 | Select-Object Host,HostInfo,Subnets,HAGroups
    } else {
        return $Results
    }
}