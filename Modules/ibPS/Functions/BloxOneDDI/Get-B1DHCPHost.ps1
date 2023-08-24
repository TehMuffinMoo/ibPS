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

    .Example
        Get-B1DHCPHost -Name "bloxoneddihost1.mydomain.corp" -IP "10.10.10.10"
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DHCP
    #>
    param(
        [String]$Name,
        [String]$IP,
        [switch]$Strict
    )
    $MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($IP) {
        $Filters.Add("address$MatchType`"$IP`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
    }
    if ($Filter) {
        Query-CSP -Method GET -Uri "dhcp/host?_filter=$Filter" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Query-CSP -Method GET -Uri "dhcp/host" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    }
}