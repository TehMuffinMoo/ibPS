﻿function Get-B1TDSecurityPolicy {
    <#
    .SYNOPSIS
        Retrieves a list of BloxOne Threat Defense Security Policies

    .DESCRIPTION
        This function is used to query a list of BloxOne Threat Defense Security Policies

    .PARAMETER Name
        Filter results by Name

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .PARAMETER id
        Filter the results by id

    .Example
        Get-B1TDSecurityPolicy -Name "Remote Users"
   
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Threat Defense
    #>
    [CmdletBinding(DefaultParameterSetName="notid")]
    param(
      [parameter(ParameterSetName="notid")]
      [String]$Name,
      [parameter(ParameterSetName="notid")]
      [Switch]$Strict,
      [parameter(ParameterSetName="id")]
      [String]$id
    )

	$MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
    }

    if ($id) {
        $Results = Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/security_policies/$id" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } elseif ($Filter) {
        $Results = Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/security_policies?_filter=$Filter" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        $Results = Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/security_policies" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }

    if ($Results) {
        return $Results
    }
}