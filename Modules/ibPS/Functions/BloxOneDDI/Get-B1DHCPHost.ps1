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

    .PARAMETER Assosications
        Obtain a list of associated subnets/ranges with this host

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
        BloxOneDDI
    
    .FUNCTIONALITY
        DHCP
    #>
    param(
        [String]$Name,
        [String]$IP,
        [switch]$Strict,
        [Int]$Limit = 1000,
        [Int]$Offset = 0,
        [String]$tfilter,
        [String[]]$Fields,
        [Switch]$Associations,
        [String]$id
    )
    $MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    [System.Collections.ArrayList]$QueryFilters = @()
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
        $Filter = Combine-Filters $Filters
        $QueryFilters.Add("_filter=$Filter") | Out-Null
    }
    $QueryFilters.Add("_limit=$Limit") | Out-Null
    $QueryFilters.Add("_offset=$Offset") | Out-Null
    if ($tfilter) {
        $QueryFilters.Add("_tfilter=$tfilter") | Out-Null
    }
    if ($Fields) {
        $Fields += "id"
        $QueryFilters.Add("_fields=$($Fields -join ",")") | Out-Null
    }
    if ($QueryFilters) {
        $QueryString = ConvertTo-QueryString $QueryFilters
    }

    if ($QueryString) {
        $Results = Query-CSP -Method GET -Uri "dhcp/host$QueryString" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        $Results = Query-CSP -Method GET -Uri "dhcp/host" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
    if ($Results -and $Associations) {
        $AssociationResults = @()
        foreach ($DHCPHost in $Results) {
            $AssociationItem = Query-CSP -Method GET -Uri "$($DHCPHost.id)/associations"
            $AssociationResults += @{
                "Host" = $DHCPHost.name
                "HostInfo" = $AssociationItem.host
                "HAGroups" = $AssociationItem.ha_groups
                "Subnets" = $AssociationItem.subnets
            }
        }
    }
    if ($AssociationResults) {
        $AssociationResults | ConvertTo-Json -Depth 15 | ConvertFrom-Json -Depth 15 | Select-Object Host,HostInfo,Subnets,HAGroups
    } else {
        return $Results
    }
}