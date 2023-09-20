function Get-B1Space {
    <#
    .SYNOPSIS
        Queries a list of BloxOneDDI IPAM/DHCP Spaces

    .DESCRIPTION
        This function is used to query a list of BloxOneDDI IPAM/DHCP Spaces

    .PARAMETER Name
        Use this parameter to filter the list of spaces by name

    .PARAMETER id
        Use this parameter to filter the list of spaces by id

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .Example
        Get-B1Space -Name "Global"
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        IPAM

    .FUNCTIONALITY
        DHCP
    #>
    param(
      [String]$Name,
      [string]$id,
      [Switch]$Strict = $false
    )

	$MatchType = Match-Type $Strict

    [System.Collections.ArrayList]$Filters = @()
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($id) {
        $Filters.Add("id$MatchType`"$id`"") | Out-Null
    }

    if ($Filters) {
        $Filter = Combine-Filters $Filters
    }

    if ($Filter) {
        $Results = Query-CSP -Uri "ipam/ip_space?_filter=$Filter" -Method GET | Select -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        $Results = Query-CSP -Uri "ipam/ip_space" -Method GET | Select -ExpandProperty results -ErrorAction SilentlyContinue
    }
    if ($Results) {
        return $Results
    } else {
        Write-Host "Error. Unable to find IPAM space: $Name" -ForegroundColor Red
        break
    }
}