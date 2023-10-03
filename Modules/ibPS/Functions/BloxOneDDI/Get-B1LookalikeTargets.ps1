function Get-B1LookalikeTargets {
    <#
    .SYNOPSIS
        Queries a list of lookalike target domains for the account

    .DESCRIPTION
        This function is used to query a list of lookalike target domains for the account
        The Lookalike Target Domains are second-level domains BloxOne uses to detect lookalike FQDNs against.

    .Example
        Get-B1LookalikeTargets
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        BloxOne Threat Defense
    #>
    param(
    )
 
    $Results = Query-CSP -Uri "$(Get-B1CspUrl)/api/tdlad/v1/lookalike_targets" -Method GET | select -ExpandProperty results -ErrorAction SilentlyContinue
  
    if ($Results) {
      return $Results
    }
}