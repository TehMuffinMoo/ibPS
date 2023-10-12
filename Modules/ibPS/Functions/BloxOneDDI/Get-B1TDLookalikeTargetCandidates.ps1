function Get-B1TDLookalikeTargetCandidates {
    <#
    .SYNOPSIS
        Queries a list of all lookalike target candidates

    .DESCRIPTION
        Use this method to retrieve information on all Lookalike Target Candidates.
        The Lookalike Target Candidates are second-level domains BloxOne uses to detect lookalike FQDNs against.

    .Example
        Get-B1TDLookalikeTargetCandidates
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        BloxOne Threat Defense
    #>
    param(
    )
 
    $Results = Query-CSP -Uri "$(Get-B1CspUrl)/api/tdlad/v1/lookalike_target_candidates" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
  
    if ($Results) {
      return $Results
    }
}