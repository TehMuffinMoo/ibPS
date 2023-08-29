function Get-B1HAGroup {
    <#
    .SYNOPSIS
        Queries a list of HA Groups from BloxOneDDI

    .DESCRIPTION
        This function is used to query a list of HA Group(s) from BloxOneDDI

    .PARAMETER Name
        The name of the HA Group to filter by

    .PARAMETER Mode
        The mode of the HA Group to filter by

    .PARAMETER Id
        The id of the HA Group to filter by

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .Example
        Get-B1HAGroup -Name "MyHAGroup" -Strict
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        IPAM

    .FUNCTIONALITY
        DHCP
    #>
    param(
      [String]$Name,
      [String]$Mode,
      [String]$Id,
      [Switch]$Strict = $false
    )

	$MatchType = Match-Type $Strict

    [System.Collections.ArrayList]$Filters = @()
    if ($Name) {
        $Filters.Add("name$MatchType`"$name`"") | Out-Null
    }
    if ($Mode) {
        if ($Mode -eq "active-active" -or $Mode -eq "active-passive") {
            $Filters.Add("mode==`"$Mode`"") | Out-Null
        } else {
            Write-Host "Error: -Mode must be `"active-active`" or `"active-passive`"" -ForegroundColor Red
            break
        }
    }
    if ($Id) {
        $Filters.Add("id==`"$id`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
    }

    if ($Filter) {
        $Results = Query-CSP -Method GET -Uri "dhcp/ha_group?_filter=$Filter" | select -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        $Results = Query-CSP -Method GET -Uri "dhcp/ha_group" | select -ExpandProperty results -ErrorAction SilentlyContinue
    }
    
    if ($Results) {
        return $Results
    } else {
        Write-Host "No DHCP HA Groups found." -ForegroundColor Gray
    }
}