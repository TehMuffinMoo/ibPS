function Get-B1LookalikeTargetCandidates {
    <#
    .SYNOPSIS
        Queries a list of all lookalike target candidates

    .DESCRIPTION
        Use this method to retrieve information on all Lookalike Target Candidates.
        The Lookalike Target Candidates are second-level domains BloxOne uses to detect lookalike FQDNs against.

    .PARAMETER AccountSpecific
        Determines whether to return account_specific or common candidates. Default value is false, i.e. returns common candidates.

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

    .EXAMPLE
        PS> Get-B1LookalikeTargetCandidates -AccountSpecific

        name                                      description    items_described                                                item_count
        ----                                      -----------    ---------------                                                ----------
        Account Specific Lookalike Candidate List Auto-generated {@{item=infoblox.com; selected=True; query_count_daily=28350}}          1

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        BloxOne Threat Defense
    #>
    [CmdletBinding()]
    param(
        [Switch]$AccountSpecific
    )

    [System.Collections.ArrayList]$QueryFilters = @()
    if ($AccountSpecific) {
        $QueryFilters.Add("account_specific=$true") | Out-Null
    }
    if ($QueryFilters) {
        $QueryString = ConvertTo-QueryString $QueryFilters
    }
    Write-DebugMsg -Filters $QueryFilters
    if ($QueryString) {
        $Results = Invoke-CSP -Uri "$(Get-B1CspUrl)/api/tdlad/v1/lookalike_target_candidates$QueryString" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        $Results = Invoke-CSP -Uri "$(Get-B1CspUrl)/api/tdlad/v1/lookalike_target_candidates" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
    if ($Results) {
      return $Results
    }
}