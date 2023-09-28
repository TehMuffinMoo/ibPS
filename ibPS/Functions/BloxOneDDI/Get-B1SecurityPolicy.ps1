function Get-B1SecurityPolicy {
    <#
    .SYNOPSIS
        Retrieves a list of BloxOne Threat Defense Security Policies

    .DESCRIPTION
        This function is used to query a list of BloxOne Threat Defense Security Policies

    .PARAMETER Name
        Filter results by Name

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .Example
        Get-B1SecurityPolicy -Name "Remote Users"
   
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Threat Defense
    #>
    param(
      [String]$Name,
      [Switch]$Strict
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
        Query-CSP -Method GET -Uri "https://csp.infoblox.com/api/atcfw/v1/security_policies?_filter=$Filter" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Query-CSP -Method GET -Uri "https://csp.infoblox.com/api/atcfw/v1/security_policies" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    }
}