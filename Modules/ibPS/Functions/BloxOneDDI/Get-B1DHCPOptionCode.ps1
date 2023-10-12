function Get-B1DHCPOptionCode {
    <#
    .SYNOPSIS
        Retrieves a list of DHCP option codes from BloxOneDDI

    .DESCRIPTION
        This function is used to query a list DHCP option codes from BloxOneDDI. This is useful for determining the option code required when submitting options via the -DHCPOptions parameter on other cmdlets.

    .PARAMETER Name
        The name of the DHCP option to filter by

    .PARAMETER Code
        The code of the DHCP option to filter by

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .Example
        Get-B1DHCPOptionCode -Name "routers"
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DHCP
    #>
    param(
        [String]$Name,
        [int]$Code,
        [String]$Source,
        [Switch]$Strict = $false
    )
	$MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($Code) {
        $Filters.Add("code$MatchType$Code") | Out-Null
    }
    if ($Source) {
        $Filters.Add("source$MatchType`"$Source`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
    }

    if ($Filter) {
        Query-CSP -Method GET -Uri "dhcp/option_code?_filter=$Filter" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Query-CSP -Method GET -Uri "dhcp/option_code" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
}