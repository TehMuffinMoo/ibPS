function Get-B1FixedAddress {
    <#
    .SYNOPSIS
        Retrieves a list of Fixed Addresses in BloxOneDDI IPAM

    .DESCRIPTION
        This function is used to query a list of Fixed Addresses in BloxOneDDI IPAM

    .PARAMETER IP
        The IP of the fixed address

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .Example
        Get-B1FixedAddress -IP 10.10.100.12
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DHCP
    #>
    param(
        [String]$IP = $null,
        [Switch]$Strict = $false
    )
	$MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    if ($IP) {
        $Filters.Add("address==`"$IP`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
    }

    if ($Filter) {
        Query-CSP -Method GET -Uri "dhcp/fixed_address?_filter=$Filter" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Query-CSP -Method GET -Uri "dhcp/fixed_address" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    }
}