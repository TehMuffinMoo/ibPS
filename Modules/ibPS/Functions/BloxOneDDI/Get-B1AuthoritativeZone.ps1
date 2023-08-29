function Get-B1AuthoritativeZone {
    <#
    .SYNOPSIS
        Retrieves a list of authoritative zones from BloxOneDDI

    .DESCRIPTION
        This function is used to query a list authoritative zones from BloxOneDDI

    .PARAMETER FQDN
        The fqdn of the authoritative zone to filter by

    .PARAMETER Disabled
        Filter results based on if the authoritative zone is disabled or not

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .PARAMETER View
        The DNS View where the authoritative zone(s) are located

    .PARAMETER id
        The id of the authoritative zone to filter by

    .Example
        Get-B1AuthoritativeZone -FQDN "prod.mydomain.corp"
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DNS
    #>
    param(
      [String]$FQDN,
      [bool]$Disabled,
      [Switch]$Strict = $false,
      [String]$View,
      [String]$id
    )
    if ($View) {$ViewUUID = (Get-B1DNSView -Name $View -Strict).id}
	$MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    if ($FQDN) {
        $Filters.Add("fqdn$MatchType`"$FQDN`"") | Out-Null
    }
    if ($Disabled) {
        $Filters.Add("disabled==`"$Disabled`"") | Out-Null
    }
    if ($ViewUUID) {
        $Filters.Add("view==`"$ViewUUID`"") | Out-Null
    }
    if ($id) {
        $Filters.Add("id==`"$id`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
    }

    if ($Filter) {
        Query-CSP -Method GET -Uri "dns/auth_zone?_filter=$Filter" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Query-CSP -Method GET -Uri "dns/auth_zone" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    }
}