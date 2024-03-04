function Get-B1DHCPOptionSpace {
    <#
    .SYNOPSIS
        Retrieves a list of DHCP option spaces from BloxOneDDI

    .DESCRIPTION
        This function is used to query a list DHCP option spaces from BloxOneDDI.

    .PARAMETER Name
        The name of the DHCP option space to filter by

    .PARAMETER Protocol
        The IP version protocol to filter the DHCP option spaces by

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .PARAMETER Fields
        Specify a list of fields to return. The default is to return all fields.
        
    .EXAMPLE
        PS> Get-B1DHCPOptionSpace -Name dhcp4 -Protocol ip4 -Strict
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DHCP
    #>
    param(
        [String]$Name,
        [ValidateSet("ip4","ip6")]
        [String]$Protocol,
        [String[]]$Fields,
        [Switch]$Strict = $false
    )
	$MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    [System.Collections.ArrayList]$QueryFilters = @()
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($Protocol) {
        $Filters.Add("protocol$MatchType`"$Protocol`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
        $QueryFilters.Add("_filter=$Filter") | Out-Null
    }

    if ($Fields) {
        $Fields += "id"
        $QueryFilters.Add("_fields=$($Fields -join ",")") | Out-Null
    }
    if ($QueryFilters) {
        $QueryString = ConvertTo-QueryString $QueryFilters
    }

    if ($QueryString) {
        Query-CSP -Method GET -Uri "dhcp/option_space$($QueryString)" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Query-CSP -Method GET -Uri "dhcp/option_space" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
}