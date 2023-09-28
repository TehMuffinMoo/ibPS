function Get-B1DNSView {
    <#
    .SYNOPSIS
        Retrieves a list of BloxOneDDI DNS Views

    .DESCRIPTION
        This function is used to query a list of BloxOneDDI DNS Views

    .PARAMETER Name
        The name of the DNS View to filter by

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .Example
        Get-B1DNSView -Name "default"
    
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
        $Results = Query-CSP -Method GET -Uri "dns/view?_filter=$Filter" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        $Results = Query-CSP -Method GET -Uri "dns/view" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    }
    if ($Results) {
        return $Results
    } else {
        Write-Host "Error. Unable to find DNS View: $Name" -ForegroundColor Red
        break
    }
}