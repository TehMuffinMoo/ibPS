function Get-B1DNSACL {
    <#
    .SYNOPSIS
        Retrieves a list of BloxOneDDI DNS Access Control Lists

    .DESCRIPTION
        This function is used to query a list of BloxOneDDI DNS Access Control Lists

    .PARAMETER Name
        The name of the DNS Access Control List to filter by

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.
        
    .EXAMPLE
        PS> Get-B1DNSACL -Name "Servers_ACL"
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DNS
    #>
    param(
        [String]$Name,
        [switch]$Strict
    )
	$MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
    }
    if ($Filter) {
        Query-CSP -Method GET -Uri "dns/acl?_filter=$Filter" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Query-CSP -Method GET -Uri "dns/acl" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
}