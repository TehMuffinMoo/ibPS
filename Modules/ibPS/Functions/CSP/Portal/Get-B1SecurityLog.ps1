﻿function Get-B1SecurityLog {
    <#
    .SYNOPSIS
        Queries the Universal DDI Security Log

    .DESCRIPTION
        This function is used to query the Universal DDI Security Log. This log contains web server information relating to the Cloud Services Portal Web UI.

    .PARAMETER Username
        The username of which you would like to filter the audit log with

    .PARAMETER ClientIP
        Used to filter the Audit Log by IP Address

    .PARAMETER Type
        Used to filter by Security Event Type, such as "nginx.access"

    .PARAMETER App
        Use this parameter to filter by App, such as "nginx"

    .PARAMETER Domain
        Use this parameter to filter by the domain of the authenticated user, such as "mycorpdomain.com"

    .PARAMETER Start
        A date parameter used as the starting date/time of the log search. By default, the search will start from 24hrs ago and returns the latest results first. You may need to increase the -Limit parameter or reduce the -End date/time to view earlier events.

    .PARAMETER End
        A date parameter used as the end date/time of the log search.

    .PARAMETER Limit
        Use this parameter to limit the quantity of results. The default number of results is 100.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .PARAMETER CustomFilters
        Accepts either an Object, ArrayList or String containing one or more custom filters.
        See here for usage: https://ibps.readthedocs.io/en/latest/#-customfilters

    .PARAMETER Raw
        Return results as raw without additional parsing

    .EXAMPLE
        PS> Get-B1SecurityLog -Limit "25" -Offset "0" -Username "my.email@domain.com" -App "nginx" -Type "nginx.access" -Domain "domain.com"

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        Logs
    #>
    [CmdletBinding()]
    param(
      [string]$Username,
      [string]$ClientIP,
      [string]$Type,
      [string]$App,
      [string]$Domain,
      [datetime]$Start = (Get-Date).AddDays(-1),
      [datetime]$End = (Get-Date),
      [Int]$Limit = 100,
      [Int]$Offset,
      [switch]$Strict,
      $CustomFilters,
      [switch]$Raw
    )

    $Start = $Start.ToUniversalTime()
    $End = $End.ToUniversalTime()

	$MatchType = Match-Type $Strict

    [System.Collections.ArrayList]$Filters = @()
    [System.Collections.ArrayList]$QueryFilters = @()
    if ($CustomFilters) {
        $Filters.Add($CustomFilters) | Out-Null
    }
    if ($Username) {
        $Filters.Add("userEmail$MatchType`"$Username`"") | Out-Null
    }
    if ($Type) {
        $Filters.Add("security_event_type$MatchType`"$Type`"") | Out-Null
    }
    if ($App) {
        $Filters.Add("app$MatchType`"$App`"") | Out-Null
    }
    if ($ClientIP) {
        $Filters.Add("remote_addr==`"$ClientIP`"") | Out-Null
    }
    if ($Domain) {
        $Filters.Add("domain==$Domain") | Out-Null
    }
    if ($Start) {
        $StartTime = $Start.ToString("yyyy-MM-ddTHH:mm:ssZ")
        $Filters.Add("start_time==`"$StartTime`"") | Out-Null
    }
    if ($End) {
        $EndTime = $End.ToString("yyyy-MM-ddTHH:mm:ssZ")
        $Filters.Add("end_time==`"$EndTime`"") | Out-Null
    }

    if ($Filters) {
        $Filter = Combine-Filters $Filters
        $QueryFilters.Add("_filter=$Filter") | Out-Null
    }
    $QueryFilters.Add("_limit=$Limit") | Out-Null
    $QueryFilters.Add("_offset=$Offset") | Out-Null

    if ($QueryFilters) {
        $QueryString = ConvertTo-QueryString $QueryFilters
    }
    Write-DebugMsg -Filters $QueryFilters
    if ($QueryString) {
        $Results = Invoke-CSP -Uri "$(Get-B1CSPUrl)/security-events/v1/security_events$($QueryString)" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        $Results = Invoke-CSP -Uri "$(Get-B1CSPUrl)/security-events/v1/security_events" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
    if ($Results) {
        if ($Raw) {
            return $Results
        } else {
            $Results.log | ConvertFrom-Json | ConvertFrom-Json
        }
    } else {
        Write-Host "Error. Unable to find any security logs." -ForegroundColor Red
        break
    }
}