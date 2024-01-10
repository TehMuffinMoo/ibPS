function Get-B1DFP {
    <#
    .SYNOPSIS
        Queries a list of BloxOneDDI DFPs (DNS Forwarding Proxies)

    .DESCRIPTION
        Use this method query a list of BloxOneDDI DFPs (DNS Forwarding Proxies)

    .PARAMETER Name
        Filter the results by name

    .PARAMETER SiteID
        Filter the results by site_id

    .PARAMETER OPHID
        Filter the results by ophid

    .PARAMETER PolicyID
        Filter the results by policy_id

    .PARAMETER DefaultSecurityPolicy
        Switch value to filter by default security policy

    .PARAMETER id
        Filter the results by id

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .PARAMETER Fields
        Specify a list of fields to return. The default is to return all fields.
        
    .EXAMPLE
        Get-B1DFP -Name "My DFP" -Strict

    .EXAMPLE
        Get-B1DFP -DefaultSecurityPolicy

    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        BloxOne Threat Defense
    #>
    param(
        [String[]]$Name,
        [String]$SiteID,
        [String]$OPHID,
        [Int]$PolicyID,
        [Switch]$DefaultSecurityPolicy,
        [Switch]$Strict,
        [String[]]$Fields,
        [String]$id
    )
 
    $MatchType = Match-Type $Strict

    [System.Collections.ArrayList]$Filters = @()
    [System.Collections.ArrayList]$QueryFilters = @()
    if ($Name) {
      $Filters += "name$($MatchType)`"$Name`""
    }
    if ($SiteID) {
      $Filters += "site_id$($MatchType)`"$SiteID`""
    }
    if ($OPHID) {
      $Filters += "ophid$($MatchType)`"$OPHID`""
    }
    if ($PolicyID) {
      $Filters += "policy_id==$PolicyID"
    }
    if ($id) {
      $Filters += "id==$id"
    }
    if ($DefaultSecurityPolicy) {
      $Filters += "default_security_policy==$DefaultSecurityPolicy"
    }
    if ($Filters) {
        $Filter = (Combine-Filters $Filters)
        $QueryFilters.Add("_filter=$Filter") | Out-Null
    }
    if ($Fields) {
      $Fields += "id"
      $QueryFilters.Add("_fields=$($Fields -join ",")") | Out-Null
    }
    if ($QueryFilters) {
      $QueryString = ConvertTo-QueryString $QueryFilters
    }
    
    if ($id) {
      $Results = Query-CSP -Uri "$(Get-B1CspUrl)/api/atcdfp/v1/dfps/$id$QueryString" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } elseif ($QueryString) {
      $Results = Query-CSP -Uri "$(Get-B1CspUrl)/api/atcdfp/v1/dfps$QueryString" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
      $Results = Query-CSP -Uri "$(Get-B1CspUrl)/api/atcdfp/v1/dfps" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
  
    if ($Results) {
      return $Results
    }
}