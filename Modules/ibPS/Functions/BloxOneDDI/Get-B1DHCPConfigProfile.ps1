function Get-B1DHCPConfigProfile {
    <#
    .SYNOPSIS
        Retrieves a list of DHCP Config Profiles from BloxOneDDI

    .DESCRIPTION
        This function is used to query a list of DHCP Config Profiles from BloxOneDDI

    .PARAMETER Name
        The name of the DHCP Config Profile

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .PARAMETER IncludeInheritance
        Include inherited configuration in results

    .PARAMETER id
        Return results based on DHCP Config Profile id

    .Example
        Get-B1DHCPConfigProfile -Name "Data Centre" -Strict -IncludeInheritance
    
    .FUNCTIONALITY
        BloxOneDDI
    #>
    param(
        [String]$Name,
        [switch]$Strict = $false,
        [switch]$IncludeInheritance = $false,
        [string]$id
    )
    $MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($id) {
        $Filters.Add("id==`"$id`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
    }
    if ($Filter) {
        if ($IncludeInheritance) {
            Query-CSP -Method GET -Uri "dhcp/server?_filter=$Filter&_inherit=full" | Select -ExpandProperty results -ErrorAction SilentlyContinue
        } else {
            Query-CSP -Method GET -Uri "dhcp/server?_filter=$Filter" | Select -ExpandProperty results -ErrorAction SilentlyContinue
        }
    } else {
        if ($IncludeInheritance) {
            Query-CSP -Method GET -Uri "dhcp/server?_inherit=full" | Select -ExpandProperty results -ErrorAction SilentlyContinue
        } else {
            Query-CSP -Method GET -Uri "dhcp/server" | Select -ExpandProperty results -ErrorAction SilentlyContinue
        }
    }
}