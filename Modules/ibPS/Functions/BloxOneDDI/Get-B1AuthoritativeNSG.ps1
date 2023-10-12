function Get-B1AuthoritativeNSG {
    <#
    .SYNOPSIS
        Retrieves a list of Authoritative DNS Server Groups from BloxOneDDI

    .DESCRIPTION
        This function is used to query a list Authoritative DNS Server Groups from BloxOneDDI

    .PARAMETER Name
        The name of the Authoritative DNS Server Group

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .Example
        Get-B1AuthoritativeNSG -Name "Data Centre" -Strict
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DNS
    #>
    param(
        [String]$Name,
        [Switch]$Strict = $false
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
        Query-CSP -Method GET -Uri "dns/auth_nsg?_filter=$Filter" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Query-CSP -Method GET -Uri "dns/auth_nsg" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
}