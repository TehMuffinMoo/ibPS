function Get-B1DHCPOptionGroup {
    <#
    .SYNOPSIS
        Retrieves a list of DHCP option groups from BloxOneDDI

    .DESCRIPTION
        This function is used to query a list DHCP option groups from BloxOneDDI.

    .PARAMETER Name
        The name of the DHCP group to filter by

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .Example
        Get-B1DHCPOptionGroup -Name "Telephony Options"
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DHCP
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
        Query-CSP -Method GET -Uri "dhcp/option_group?_filter=$Filter" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Query-CSP -Method GET -Uri "dhcp/option_group" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    }
}