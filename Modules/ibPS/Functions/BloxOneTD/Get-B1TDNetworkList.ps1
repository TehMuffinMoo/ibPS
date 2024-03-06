function Get-B1TDNetworkList {
    <#
    .SYNOPSIS
        Retrieves network lists from BloxOne Threat Defense

    .DESCRIPTION
        This function is used to retrieve network lists from BloxOne Threat Defense

    .PARAMETER Name
        Filter results by Name

    .PARAMETER Description
        Filter results by Description

    .PARAMETER PolicyID
        Filter results by policy_id

    .PARAMETER DefaultSecurityPolicy
        Filter results by those assigned to the default security policy

    .PARAMETER id
        Filter the results by id

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .EXAMPLE
        PS> Get-B1TDNetworkList -Name "something"
   
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
      [String]$Description,
      [parameter(ParameterSetName="notid")]
      [Int]$PolicyID,
      [parameter(ParameterSetName="notid")]
      [Switch]$DefaultSecurityPolicy,
      [parameter(ParameterSetName="id")]
      [Int]$id,
      [parameter(ParameterSetName="notid")]
      [Switch]$Strict
    )

    $MatchType = Match-Type $Strict

    [System.Collections.ArrayList]$Filters = @()
    if ($Name) {
        $Filters.Add("name$($MatchType)`"$Name`"") | Out-Null
    }
    if ($Description) {
        $Filters.Add("description$($MatchType)`"$Description`"") | Out-Null
    }
    if ($PolicyID) {
        $Filters.Add("policy_id==$PolicyID") | Out-Null
    }
    if ($DefaultSecurityPolicy) {
        $Filters.Add("default_security_policy==`"$DefaultSecurityPolicy`"") | Out-Null
    }
    if ($id) {
        $Filters.Add("id==$id") | Out-Null
    }
    if ($Location) {
        $Filters.Add("location~`"$Location`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
    }

    if ($Filter) {
        $Results = Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/network_lists?_filter=$Filter" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        $Results = Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/network_lists" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }

    if ($Results) {
        return $Results
    }
}