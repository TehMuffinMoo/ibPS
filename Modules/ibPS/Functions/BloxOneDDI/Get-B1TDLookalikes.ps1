function Get-B1TDLookalikes {
    <#
    .SYNOPSIS
        Queries a list of lookalike domains

    .DESCRIPTION
        This function is used to retrieve information on lookalike domains

    .PARAMETER Domain
        Filter the results by target domain

    .PARAMETER LookalikeDomain
        Filter the results by lookalike domain

    .PARAMETER Reason
        Filter the results by reason

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .PARAMETER Limit
        Use this parameter to limit the quantity of results returned from the Audit Log. The default number of results is 100.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .Example
        Get-B1TDLookalikes -Domain google.com -Reason "phishing"
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        BloxOne Threat Defense
    #>
    param(
      [String]$Domain,
      [String]$LookalikeDomain,
      [String]$Reason,
      [Int]$Limit = 1000,
      [Int]$Offset = 0,
      [Switch]$Strict
    )

    $MatchType = Match-Type $Strict

    [System.Collections.ArrayList]$Filters = @()
    if ($Domain) {
      $Filters += "target_domain$($MatchType)`"$Domain`""
    }
    if ($LookalikeDomain) {
      $Filters += "lookalike_domain$($MatchType)`"$LookalikeDomain`""
    }
    if ($Reason) {
      $Filters += "reason$($MatchType)`"$Reason`""
    }

    if ($Filters) {
        $Filter = "_filter="+(Combine-Filters $Filters)
    }
 
    if ($Filter) {
        $Results = Query-CSP -Uri "$(Get-B1CspUrl)/api/tdlad/v1/lookalikes?$Filter&_limit=$Limit&_offset=$Offset" -Method GET | select -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        $Results = Query-CSP -Uri "$(Get-B1CspUrl)/api/tdlad/v1/lookalikes?_limit=$Limit&_offset=$Offset" -Method GET | select -ExpandProperty results -ErrorAction SilentlyContinue
    }
  
    if ($Results) {
      return $Results
    }
}