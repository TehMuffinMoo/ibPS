﻿function Get-B1Space {
    <#
    .SYNOPSIS
        Queries a list of BloxOneDDI IPAM/DHCP Spaces

    .DESCRIPTION
        This function is used to query a list of BloxOneDDI IPAM/DHCP Spaces

    .PARAMETER Name
        Use this parameter to filter the list of spaces by name

    .PARAMETER tfilter
        Use this parameter to filter the results returned by tag.

    .PARAMETER id
        Use this parameter to filter the list of spaces by id

    .PARAMETER Limit
        Use this parameter to limit the quantity of results. The default number of results is 1000.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .EXAMPLE
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
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($id) {
        $Filters.Add("id$MatchType`"$id`"") | Out-Null
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
        $Results = Query-CSP -Uri "ipam/ip_space$($Filter2)" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        $Results = Query-CSP -Uri "ipam/ip_space" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
    if ($Results) {
        return $Results
    } else {
        Write-Host "Error. Unable to find IPAM space: $Name" -ForegroundColor Red
        break
    }
}