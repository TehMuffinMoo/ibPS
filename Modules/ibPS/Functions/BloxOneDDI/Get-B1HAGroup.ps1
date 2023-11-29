﻿function Get-B1HAGroup {
    <#
    .SYNOPSIS
        Queries a list of HA Groups from BloxOneDDI

    .DESCRIPTION
        This function is used to query a list of HA Group(s) from BloxOneDDI

    .PARAMETER Name
        The name of the HA Group to filter by

    .PARAMETER Mode
        The mode of the HA Group to filter by

    .PARAMETER Limit
        Use this parameter to limit the quantity of results. The default number of results is 1000.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .PARAMETER tfilter
        Use this parameter to filter the results returned by tag.

    .PARAMETER id
        The id of the HA Group to filter by

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .EXAMPLE
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
      [Switch]$Strict = $false,
      [Int]$Limit = 1000,
      [Int]$Offset = 0,
      [String]$tfilter,
      [String]$id
    )

	$MatchType = Match-Type $Strict

    [System.Collections.ArrayList]$Filters = @()
    [System.Collections.ArrayList]$Filters2 = @()
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
    if ($id) {
        $Filters.Add("id==`"$id`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
        $Filters2.Add("_filter=$Filter") | Out-Null
    }
    $Filters2.Add("_limit=$Limit") | Out-Null
    $Filters2.Add("_offset=$Offset") | Out-Null
    if ($tfilter) {
        $Filters2.Add("_tfilter=$tfilter") | Out-Null
    }
    if ($Filters2) {
        $Filter2 = Combine-Filters2 $Filters2
    }

    if ($Filter2) {
        $Results = Query-CSP -Method GET -Uri "dhcp/ha_group$($Filter2)" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        $Results = Query-CSP -Method GET -Uri "dhcp/ha_group" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
    
    if ($Results) {
        return $Results
    } else {
        Write-Verbose "No DHCP HA Groups found."
    }
}