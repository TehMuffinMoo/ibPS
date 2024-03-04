function Get-B1TDSecurityPolicyRules {
    <#
    .SYNOPSIS
        Use this cmdlet to retrieve a list of security policy rules

    .DESCRIPTION
        Use this cmdlet to retrieve information on of security policy rules

    .PARAMETER PolicyID
        Filter results by policy_id

    .PARAMETER ListID
        Filter results by list_id

    .PARAMETER CategoryFilterID
        Filter results by category_filter_id
    
    .EXAMPLE
        PS> Get-B1TDSecurityPolicyRules 
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        BloxOne Threat Defense
    #>
    param(
        [Int]$PolicyID,
        [Int]$ListID,
        [Int]$CategoryFilterID
    )

    [System.Collections.ArrayList]$Filters = @()

    if ($PolicyID) {
        $Filters.Add("policy_id==$PolicyID") | Out-Null
    }
    if ($ListID) {
        $Filters.Add("list_id==$ListID") | Out-Null
    }
    if ($CategoryFilterID) {
        $Filters.Add("category_filter_id==$CategoryFilterID") | Out-Null
    }

    if ($Filters) {
        $Filter = Combine-Filters $Filters
    }

    if ($Filter) {
      $Results = Query-CSP -Uri "$(Get-B1CspUrl)/api/atcfw/v1/security_policy_rules?_filter=$Filter" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
      $Results = Query-CSP -Uri "$(Get-B1CspUrl)/api/atcfw/v1/security_policy_rules" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
  
    if ($Results) {
      return $Results
    }
}