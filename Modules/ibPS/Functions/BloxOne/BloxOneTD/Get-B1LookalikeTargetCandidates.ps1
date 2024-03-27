function Get-B1LookalikeTargetCandidates {
    <#
    .SYNOPSIS
        Queries a list of all lookalike target candidates

    .DESCRIPTION
        Use this method to retrieve information on all Lookalike Target Candidates.
        The Lookalike Target Candidates are second-level domains BloxOne uses to detect lookalike FQDNs against.

    .EXAMPLE
        PS> Get-B1LookalikeTargetCandidates                                                                                                

        name                             description    items_described                                                                                                                     item_count
        ----                             -----------    ---------------                                                                                                                     ----------
        Global Lookalike Candidates List Auto-generated {@{item=accuweather.com; selected=True}, @{item=active.aero}, @{item=adobe.com; selected=True}, @{item=airbnb.com; selected=True}…}        123

    .EXAMPLE
        PS> Get-B1LookalikeTargetCandidates | Select-Object -ExpandProperty items_described

        item                        selected
        ----                        --------
        accuweather.com                 True
        active.aero                         
        adobe.com                       True
        airbnb.com                      True
        alibaba.com                         
        aliexpress.com                  True
        amazonaws.com                   True
        amazon.com                      True
        americafirst.com                True
        americanexpressbusiness.com         
        ...
    
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